Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYIXNKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYIXNKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIXNK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:10:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:6844 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYIXNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=l7VaZtuC4XvlssM/UR7x/gV3dUeBzfw2u212vGRGU1Bus5ymB1Wd6aMOxEatnsYvbA
         GHCZc7HlbLriuplFHDRWy2atgFCwlmFR1ZYNiJyDAa0xC33h1oWrZMHi1DJ7wR/w5ure
         Pl45eBQ3laxzjtVRxlTwouG4c6BSI1n9ScDuQ=
Date: Wed, 24 Sep 2008 21:10:19 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 2/2] Suppress false "mtrr all empty" warning message
	when running as VMware guest
Message-ID: <20080924131018.GA17256@yantp.cn.ibm.com>
References: <a120cfa37281607d8dc361deda1a35419accd193.1222258080.git.elliot.li.tech@gmail.com> <48da36b3.0e0d6e0a.1c8e.fffff980@mx.google.com> <1222260854.4166.3.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1222260854.4166.3.camel@frecb07144>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 02:54:14PM +0200, Laurent Vivier wrote:
> Le mercredi 24 septembre 2008 à 20:24 +0800, Yan Li a écrit :
> > +#ifdef CONFIG_VMWARE_GUEST_DETECT
> > +		/* the "mtrr all blank" warning will be deferred until
> > +		 * after DMI scanning and we know the machine is not a
> > +		 * VMware guest
> > +		 */
> > +		printk(KERN_INFO "CPU MTRRs all blank\n");
> > +		return EMTRR_ALL_BLANK;
> > +#else
> >  		WARN(!kvm_para_available(), KERN_WARNING
> >  				"WARNING: strange, CPU MTRRs all blank?\n");
> >  		return 0;
> > +#endif
> >  	}
> 
> perhaps something like:
> 
> #ifdef CONFIG_VMWARE_GUEST_DETECT
>  		WARN(!kvm_para_available() && !is_vmware_guest(), KERN_WARNING
> 				"WARNING: strange, CPU MTRRs all blank?\n");
> #else
>  		WARN(!kvm_para_available(), KERN_WARNING
>   				"WARNING: strange, CPU MTRRs all blank?\n");
> ...
> 
> ???

As stated in the comments: the warning has to be deferred. The reason
is that "is_vmware_guest()" replies on DMI and can only be used after
dmi_scan().  These mtrr codes here are run very early during
setup_arch() when the DMI is not available. So when I've detected all
MTRRs are blank, I returned a status code to setup_arch(), who will
call "is_vmware_guest()" later, after dmi_scan(), to decide whether to
issue a warning or not.


-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
