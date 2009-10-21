Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZJUWQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZJUWQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbZJUWQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:16:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:43016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZJUWQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fz0FzAAk0pUeqio4yGEYevKejKTbMaQTkOByWGMo2P2V9tvYKk1WMEQhL8eTFPCm8Q
         nCHrjAsvXmO2+JNH/nNKM+TojvqdsKNGcnJeqO+ynKopUmHFBlYG0rgVJQn/aFHPqG13
         lamlJxREmktW9K7gGj0V4epShc14PzKxAPVbY=
Date: Thu, 22 Oct 2009 00:16:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
Subject: Re: [PATCH] macintosh: Explicitly set llseek to no_llseek in
	ans-lcd
Message-ID: <20091021221619.GF4880@nowhere>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de> <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain> <20091021212137.GB4880@nowhere> <alpine.LFD.2.00.0910212327160.3526@localhost.localdomain> <20091021214537.GD4880@nowhere> <alpine.LFD.2.00.0910212350210.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910212350210.3526@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:53:21PM +0200, John Kacur wrote:
> > No problem with that. Setting no_llseek or generic_file_llseek_unlocked,
> > depending on the context is the right thing to do.
> > 
> > What I'm wondering about concerns the future code that will have
> > no llsek() implemented in their fops.
> > 
> > We can't continue to use default_llseek() for future code unless we
> > want to continue these post reviews and fixes forever.
> > 
> 
> I'm thinking that the simplier approach, would be to make the 
> default_llseek the unlocked one. Then you only have to audit the drivers 
> that have the BKL - ie the ones we are auditing anyway, and explicitly set 
> them to the bkl locked llseek.
> 
> There might be a hidden interaction though between the non-unlocked 
> variety of ioctls and default llseek though.


I fear that won't work because the bkl in default_llseek() does not
only synchronizes with others uses of the bkl in a driver, it also
synchronizes lseek() itself.

As an example offset change is not atomic. This is a long long, so
updating its value is not atomic in 32 bits archs.

