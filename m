Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYIKHyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYIKHyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 03:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYIKHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 03:54:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48222 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYIKHyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 03:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pdBw568y0D2GYYsxfDxxbyd8Nn0DHMixktOkW6s25X7jvvuB/rsfUYpUp9Zmi5fcQd
         izhC1kn6tXiznBXOQVviIslkZbQpYKt8sQ2SC0aCOcDkfVyroKrDv+X2v4SsVx3S7l2L
         Oc/r/B8QSRJO2fomVwEbUceirqduxZ80XBjT4=
Date: Thu, 11 Sep 2008 09:54:38 +0200
From: Adam Tkac <vonsch@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-ID: <20080911075438.GA2882@traged.atkac.englab.brq.redhat.com>
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com> <20080910143141.a3bc8258.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910143141.a3bc8258.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:31:41PM -0700, Andrew Morton wrote:
> On Tue, 9 Sep 2008 09:14:07 +0200
> Adam Tkac <vonsch@gmail.com> wrote:
> 
> > when process wants set limit of open files to RLIM_INFINITY it gets
> > EPERM even if it has CAP_SYS_RESOURCE capability. Attached patch
> > should fix the problem. Please add me to CC of your responses because
> > I'm not member of list.
> > 
> > Regards, Adam
> > 
> > -- 
> > Adam Tkac
> > 
> > 
> > [linux26-openfiles.patch  text/plain (634B)]
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1458,8 +1458,14 @@ asmlinkage long sys_setrlimit(unsigned i
> >  	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> >  	    !capable(CAP_SYS_RESOURCE))
> >  		return -EPERM;
> > -	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
> > -		return -EPERM;
> > +	if (resource == RLIMIT_NOFILE) {
> > +		if (new_rlim.rlim_max == RLIM_INFINITY)
> > +			new_rlim.rlim_max = sysctl_nr_open;
> > +		if (new_rlim.rlim_cur == RLIM_INFINITY)
> > +			new_rlim.rlim_cur = sysctl_nr_open;
> > +		if (new_rlim.rlim_max > sysctl_nr_open)
> > +			return -EPERM;
> > +	}
> 
> The kernel has had this behaviour for a long time.  2.6.13 had:
> 
> 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> 	    !capable(CAP_SYS_RESOURCE))
> 		return -EPERM;
> 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
> 			return -EPERM;
> 
> I don't immediately see a problem with your change, but what makes you
> believe that it is needed?  Is there some standard which we're
> violating?  Is there some operational situation in which the current
> behaviour is causing a problem?
> 
> Thanks.

Well, this change is not _absolutely_ needed because everyone who wants
unlimited file descriptors he could set it to NR_OPEN. Look on
example (from BIND):

...
#elif defined(NR_OPEN) && defined(__linux__)
        /*
         * Some Linux kernels don't accept RLIM_INFINIT; the maximum
         * possible value is the NR_OPEN defined in linux/fs.h.
         */
        if (resource == isc_resource_openfiles && rlim_value == RLIM_INFINITY) {
                rl.rlim_cur = rl.rlim_max = NR_OPEN;
                unixresult = setrlimit(unixresource, &rl);
                if (unixresult == 0)
                        return (ISC_R_SUCCESS);
        }
#elif ...

I think that when you allow set RLIMIT_NOFILE to RLIM_INFINITY you
increase portability - you don't have to check if OS is linux and then
use different schema for limits.

Regards, Adam

-- 
Adam Tkac
