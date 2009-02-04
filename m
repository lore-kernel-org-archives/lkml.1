Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZBDSMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZBDSMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbZBDSLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:11:53 -0500
Received: from [84.77.67.98] ([84.77.67.98]:4843 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbZBDSLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:11:52 -0500
Date: Wed, 4 Feb 2009 19:12:20 +0100
From: Luca Olivetti <luca@ventoso.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
Message-ID: <20090204191220.1ffe35de@noname>
In-Reply-To: <1233763938.15119.92.camel@desktop>
References: <20090203172836.GA6964@elte.hu>
	<1233685361.5903.131.camel@desktop>
	<20090203193029.GA13726@elte.hu>
	<4988ABEE.6020703@ventoso.org>
	<1233710080.15119.37.camel@desktop>
	<4989ABA8.8010807@ventoso.org>
	<1233760607.15119.85.camel@desktop>
	<4989B913.1020702@ventoso.org>
	<1233763938.15119.92.camel@desktop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.10.12; arm-unknown-linux-gnueabi)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 04 Feb 2009 08:12:18 -0800
Daniel Walker <dwalker@fifo99.com> escribió:
> On Wed, 2009-02-04 at 16:49 +0100, Luca Olivetti wrote:
> > 
> > No, I havent: the source file isn't compiled, so those symbols are 
> > unavailable to the linker.
> > The only reference I could find (well, I haven't searched that
> > much) on the expected behaviour of the linker when a weak attribute
> > is not found is this:
> > 
> > http://software.intel.com/en-us/articles/software-convention-models-using-elf-visibility-attributes/
> > 
> > "# STB_WEAK. A weak symbol behaves as does a global symbol, with a
> > few differences. If there are both a weak and a global definition
> > of a name, the global definition takes precedence and any weak
> > definitions are ignored. The Linker will not extract archive
> > members to resolve undefined weak symbols. It is not an error to
> > have unresolved weak references; unresolved weak symbols have the
> > value zero. "
> 
> I wrote a little test to see if this was true in gcc, and it does
> appear to give a NULL in a simple case. However, after reviewing
> Ingo's disassmbled function it look like the crash is happening on
> this line,
> 
> /* module stuff */
> static int __init af9005_usb_module_init(void)
> {
>         int result;
>         if ((result = usb_register(&af9005_usb_driver))) {
>                 err("usb_register failed. (%d)", result);
>                 return result;
>         }
>         rc_decode = symbol_request(af9005_rc_decode);
>         rc_keys = symbol_request(af9005_rc_keys);
>         rc_keys_size = symbol_request(af9005_rc_keys_size);
>         if (rc_decode == NULL || rc_keys == NULL || rc_keys_size ==
> NULL) { err("af9005_rc_decode function not found, disabling remote");
>                 af9005_properties.rc_query = NULL;
>         } else {
>                 af9005_properties.rc_key_map = rc_keys;
>                 af9005_properties.rc_key_map_size = *rc_keys_size; /*
> <= crash !!! */ }
> 
>         return 0;
> }
> 
> That line should never run if everything is NULL ..

If so, it's not a race and my previous patch does nothing.
I guess it's the linker not doing what it should.
Your patch would solve this problem (well, it wouldn't fix the linker)
but it negates the reason I put those symbols in a different module
(i.e. to have a pluggable implementation).
Perhaps symbol_request is not the correct way to achieve that, in that
case I'd like to know if is there an alternative that doesn't break in
this way.

Bye
-- 
Luca
