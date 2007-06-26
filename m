Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbXFZWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbXFZWAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXFZWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:00:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbXFZWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:00:25 -0400
Date: Tue, 26 Jun 2007 14:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 2/2] containers: implement namespace tracking subsystem
 (v3)
Message-Id: <20070626145836.638a01cf.akpm@linux-foundation.org>
In-Reply-To: <20070613230125.GA7519@sergelap.austin.ibm.com>
References: <20070613225656.GA989@sergelap.austin.ibm.com>
	<20070613230125.GA7519@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007 18:01:25 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> @@ -177,6 +184,15 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
>  	if (IS_ERR(*new_nsp)) {
>  		err = PTR_ERR(*new_nsp);
>  		put_nsproxy(old_ns);
> +		goto out;
> +	}
> +
> +	err = ns_container_clone(current);
> +	if (err) {
> +		put_nsproxy(*new_nsp);
> +		put_nsproxy(old_ns);
>  	}
> +
> +out:
>  	return err;
>  }

I had to fix a reject here: the put_nsproxy(old_ns) has disappeared from
this code.

end result:

int unshare_nsproxy_namespaces(unsigned long unshare_flags,
		struct nsproxy **new_nsp, struct fs_struct *new_fs)
{
	int err = 0;

	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
			       CLONE_NEWUSER)))
		return 0;

	if (!capable(CAP_SYS_ADMIN))
		return -EPERM;

	*new_nsp = create_new_namespaces(unshare_flags, current,
				new_fs ? new_fs : current->fs);
	if (IS_ERR(*new_nsp))
		err = PTR_ERR(*new_nsp);
		goto out;
	}

	err = ns_container_clone(current);
	if (err)
		put_nsproxy(*new_nsp);

out:
	return err;
}

