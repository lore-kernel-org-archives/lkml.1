Return-Path: <linux-kernel-owner+w=401wt.eu-S934353AbXHHOIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbXHHOIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXHHOI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:08:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:48912 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661AbXHHOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LLx4x9xGENoYs7chB/d8HVg0IGEFqYYnLyNa1kPDvNPekgAmIt4jI2nvSnDugKd7PCPgT40UA3W55caCCnvpCiSbHZmrEJjbqSpZQNVkquhGR9HMxb0GauFR8A4a7KL/vqWiUixghgt7QQRrYVSEyYVitFP7V9GFrqzNY2i2RY0=
Message-ID: <5d6222a80708080708h43b1521cp734bedd27f94723e@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:08:25 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081144.04119.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865468394005-git-send-email-gcosta@redhat.com>
	 <11865468431616-git-send-email-gcosta@redhat.com>
	 <200708081144.04119.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
>
> > -static void discover_ebda(void)
> > +void native_ebda_info(unsigned *addr, unsigned *size)
>
> I guess it would be better to use the resources frame work here.
> Before checking EBDA check if it is already reserved. Then lguest/Xen
> can reserve these areas and stop using it.
Let's make sure I understand: So you suggest skipping discover
altogether in case it is already reserved?

>
> > +/* Overridden in paravirt.c if CONFIG_PARAVIRT */
> > +void __attribute__((weak)) memory_setup(void)
> > +{
> > +       return setup_memory_region();
> > +}
> > +
> > +
> >  void __init setup_arch(char **cmdline_p)
> >  {
> >       printk(KERN_INFO "Command line: %s\n", boot_command_line);
> > @@ -231,12 +255,19 @@ void __init setup_arch(char **cmdline_p)
> >       saved_video_mode = SAVED_VIDEO_MODE;
> >       bootloader_type = LOADER_TYPE;
> >
> > +     /*
> > +      * By returning non-zero here, a paravirt impl can choose to
> > +      * skip the rest of the setup process
> > +      */
> > +     if (paravirt_arch_setup())
> > +             return;
>
> Sorry, but that's an extremly ugly and clumpsy interface and will lead
> to extensive code duplication in hypervisors because so much code
> is disabled.

We can just wipe out the return value right now. Note that it was a
choice, it would only lead to code duplication if the hypervisor
wanted it. But yeah, I understand your concern. They may chose to
return 1 here just to change some tiny thing in the bottom.

I don't know exactly what other kinds of hooks we could put there.
lguest surely didn't need any. Are you okay with just turning it into
void by now ?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
