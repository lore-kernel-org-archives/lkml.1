Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYCHVD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYCHVD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYCHVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:03:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:20997 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYCHVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Q8Tr/Hj1ZXuep4fms2vWjYFLkWTCI5KOJ764YF+xOt8zJ9eFf4lkXs/k2y+zUd3+IB2nC8YHDyD0AYxj82DL9IcKS9QbzsksvIc4TCSzpFiRaJBnX6wYvfpcLnbNs5kNhl+N+1rKOASHYDa5+JdtKuItRSCw4iK2Jm/jEz8UZrQ=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: 2.6.25 sysdev API problem
Date: Sun, 9 Mar 2008 02:27:55 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <18386.46903.998159.519599@harpo.it.uu.se> <20080308184717.GA7476@suse.de>
In-Reply-To: <20080308184717.GA7476@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803090227.55230.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008 12:17:17 am Greg KH wrote:
> On Sat, Mar 08, 2008 at 04:56:39PM +0100, Mikael Pettersson wrote:
> > In kernels up to and including 2.6.24, it was possible to
> > register-then-unregister a sysdev_class/sys_device pair
> > multiple times. Starting with the 2.6.24-git1 kernel, doing
> > so causes a warning
> >
> > kobject (f88e96c8): tried to init an initialized object, something is
> > seriously wrong
>
> This is a warning only, I have a patch queued up to fix this.  I've
> included it below.
>
> > the second time the class/device pair is registered, followed
> > soon thereafter by random BUG()s and a kernel panic.
>
> That's odd.  I don't think that is related, but it might be.  Can you
> try the patch and let me know if it still happens?
>
> thanks,
>
> greg k-h
>
>
> From: Balaji Rao <balajirrao@gmail.com>
> Date: Thu, 6 Mar 2008 22:23:18 +0530
> Subject: kobjects: mark cleaned up kobjects as unitialized
> To: gregkh@suse.de
> Cc: <kvm-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
> Message-ID: <200803062223.18857.balajirrao@gmail.com>
> Content-Disposition: inline
>
>
> When I remove only the kvm-intel module without removing the kvm module
> itself, I get an error saying that a kobject is trying to be
> reinitialized. Its because of the fact that kvm reuses a kobject in
> kvm_init when calling sysdev_register.
>
> This patch fixes kobject_cleanup by marking the kobject as uninitialized
> when we cleanup to allow kobjects to be reused.
>
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  lib/kobject.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -577,6 +577,9 @@ static void kobject_cleanup(struct kobje
>  		pr_debug("kobject: '%s': free name\n", name);
>  		kfree(name);
>  	}
> +
> +	/* Set the state to uninitialized */
> +	kobj->state_initialized = 0;
>  }
>
>  static void kobject_release(struct kref *kref)
Hi Mikael,

The above patch causes slab corruptions as shown by this thread.
http://lkml.org/lkml/2008/3/8/94

I've posted a test fix there. Please watch this thread for updates.

-- 
regards,
balaji rao
3rd year,
Dept. of Mechanical Engineering,
National Institute of Technology, Karnataka
