Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYIKSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYIKSRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYIKSRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:17:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37379 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYIKSRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:17:04 -0400
Subject: Re: [PATCH 2/2] TPM: rcu locking
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
In-Reply-To: <20080831202808.GK7015@linux.vnet.ibm.com>
References: <cover.1220065144.git.srajiv@linux.vnet.ibm.com>
	 <5cc709bcd66c62c9e55c9bd10788fbb27efb3ede.1220065144.git.srajiv@linux.vnet.ibm.com>
	 <20080831202808.GK7015@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 14:16:46 -0400
Message-Id: <1221157006.19664.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-31 at 13:28 -0700, Paul E. McKenney wrote: 
> On Sat, Aug 30, 2008 at 12:05:04AM -0300, Rajiv Andrade wrote:
> > Continue to protect the tpm_chip_list using the driver_lock
> > as before, and add an rcu to protect readers.
> 
> A few questions interspersed below...
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > ---
> >  drivers/char/tpm/tpm.c |  268 ++++++++++++++++++++++++++++++++----------------
> >  1 files changed, 178 insertions(+), 90 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index 59b31e1..704ab01 100644
> > --- a/drivers/char/tpm/tpm.c
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -587,14 +587,22 @@ ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
> >  {
> >  	u8 *data;
> >  	ssize_t rc;
> > +	struct tpm_chip *chip;
> > +
> 
> The following five lines of code appear repeatedly.  Why not put them
> into an inline function or a macro?
> 
> Also, doesn't there need to be an rcu_dereference() somewhere either in
> this sequence of code or in either dev_get_drvdata() or get_device()?
> Or am I missing something subtle here?
> 
> >From what I see of the code, I actually don't understand why the
> rcu_read_lock() is needed here -- only tpm_chip_list is covered by
> the RCU list addition/deletion primitives in this patch.  If you are
> adding a multilinked data structure into an RCU-protected list, you
> need RCU traversal primitives only when traversing the list, not the
> data structure contained in the list.  (Of course, any changes to the
> data structure contained in the list must be protected somehow or other,
> unless there are no such changes.)
> 
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;

Ok, the rcu_read_lock is only used when accessing an rcu protected
variable, such as when walking the tpm_chip_list. When registering
the tpm chip, a pointer to the chip is stored in device->driver_data. 
The tpm_show_XXX() functions dereference and use it, which is safe if
the device is pinned when the sysfs file is opened. Documentation 
indicates that the kobject is protected from going away when attribute
files are opened. I'm not seeing the kobject refcount being incremented, 
when the attribute file is opened. How is the device being pinned?

Thanks!

Mimi Zohar

