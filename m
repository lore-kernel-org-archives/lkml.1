Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYJXUQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYJXUQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYJXUQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:16:43 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:56099 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbYJXUQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:16:41 -0400
Subject: Re: [PATCH 1/3] integrity: TPM internel kernel interface
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
In-Reply-To: <20081022144944.GC21612@us.ibm.com>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <c7ae4dc26c0c2897218851c7bdb056b4a4b49f26.1223869200.git.zohar@localhost.localdomain>
	 <20081014222312.GA18343@hallyn.com>
	 <1224679633.2786.20.camel@dyn536723.br.ibm.com>
	 <20081022144944.GC21612@us.ibm.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 18:16:03 -0200
Message-Id: <1224879363.2778.22.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge,

On Wed, 2008-10-22 at 09:49 -0500, Serge E. Hallyn wrote:
> Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> > On Tue, 2008-10-14 at 17:23 -0500, Serge E. Hallyn wrote:
> > > Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > > > The internal TPM kernel interface did not protect itself from
> > > > the removal of the TPM driver, while being used.  We continue
> > > > to protect the tpm_chip_list using the driver_lock as before,
> > > > and are using an rcu lock to protect readers. The internal TPM
> > > 
> > > I still would like to see this spelled out somewhere - correct me
> > > if I'm wrong but none of the patches sent so far have this spelled
> > > out in in-line comments, do they?
> > > 
> > > It does look sane:
> > > 
> > > 	1. writes to tpm_chip_list are protected by driver_lock
> > > 	2. readers of the list are protected by rcu
> > > 	3. chips which are read from the tpm_chip_list, if they
> > > 	   are used outside of the rcu_read_lock(), are pinned
> > > 	   using get_device(chip->dev) before releasing the
> > > 	   rcu_read_lock.
> > > 
> > > Like I say it looks sane, but something like the above summary
> > > could stand to be in a comment on top of tpm.c or something.
> > > 
> > No problem, I'll submit a patch containing a proper comment section to
> > be applied on top of these, maybe after they get accepted.
> 
> Great, thanks.
> 
> > > > kernel interface now protects itself from the driver being
> > > > removed by incrementing the module reference count.
> > > > 
> > > > Resubmitting integrity-tpm-internal-kernel-interface.patch, which
> > > > was previously Signed-off-by Kylene Hall.
> > > > Updated per feedback:
> > > > 
> > > > Adds the following support:
> > > >   - make internal kernel interface to transmit TPM commands global
> > > >   - adds reading a pcr value
> > > >   - adds extending a pcr value
> > > >   - adds lookup the tpm_chip for given chip number and type
> > > > 
> > > > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > > > Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > > 
> > > Now there are other, existing callers of tpm_transmit.  Are they
> > > all protected by sysfs pinning the kobject and thereby the device,
> > > for the duration of the call?
> > > 
> > 
> > They aren't called through sysfs, but are still protected. These new
> > functions get chip data consistently by using rcu_read. Then, after
> > computing what's intended to be written back to the chip, tpm_transmit
> > sends the new data while using tpm_mutex, so both operations are
> > performed without the risk of a race condition.
> 
> Can you show me where the refcount for dev is incremented (under the
> rcu_read_lock), either in sysfs code or tpm code?  I'm not finding
> it, but it may just be done in some subtle way that I'm glossing over.
> 

The refcount is incremented/decremented in tpm_register_hardware() and
tpm_remove_hardware() for tpm module, and tpm_open() and tpm_release()
for tpm_tis module, all inside tpm.c. The last two are referenced in
tpm_tis.c:

tpm_tis.c

static const struct file_operations tis_ops = {
        .owner = THIS_MODULE,
        .llseek = no_llseek,
        .open = tpm_open,
        .read = tpm_read,
        .write = tpm_write,
        .release = tpm_release,
};

thanks,

> thanks,
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Rajiv Andrade <srajiv@br.ibm.com>
Security Development
IBM Linux Technology Center


