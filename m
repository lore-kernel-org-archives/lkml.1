Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZBDQMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZBDQMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZBDQMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:12:33 -0500
Received: from fifo99.com ([67.223.236.141]:46050 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZBDQMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:12:31 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
In-Reply-To: <4989B913.1020702@ventoso.org>
References: <20090203172836.GA6964@elte.hu>
	 <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>
	 <4988ABEE.6020703@ventoso.org> <1233710080.15119.37.camel@desktop>
	 <4989ABA8.8010807@ventoso.org> <1233760607.15119.85.camel@desktop>
	 <4989B913.1020702@ventoso.org>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 08:12:18 -0800
Message-Id: <1233763938.15119.92.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 16:49 +0100, Luca Olivetti wrote:
> 
> No, I havent: the source file isn't compiled, so those symbols are 
> unavailable to the linker.
> The only reference I could find (well, I haven't searched that much) on 
> the expected behaviour of the linker when a weak attribute is not found 
> is this:
> 
> http://software.intel.com/en-us/articles/software-convention-models-using-elf-visibility-attributes/
> 
> "# STB_WEAK. A weak symbol behaves as does a global symbol, with a few 
> differences. If there are both a weak and a global definition of a name, 
> the global definition takes precedence and any weak definitions are 
> ignored. The Linker will not extract archive members to resolve 
> undefined weak symbols. It is not an error to have unresolved weak 
> references; unresolved weak symbols have the value zero. "

I wrote a little test to see if this was true in gcc, and it does appear
to give a NULL in a simple case. However, after reviewing Ingo's
disassmbled function it look like the crash is happening on this line,

/* module stuff */
static int __init af9005_usb_module_init(void)
{
        int result;
        if ((result = usb_register(&af9005_usb_driver))) {
                err("usb_register failed. (%d)", result);
                return result;
        }
        rc_decode = symbol_request(af9005_rc_decode);
        rc_keys = symbol_request(af9005_rc_keys);
        rc_keys_size = symbol_request(af9005_rc_keys_size);
        if (rc_decode == NULL || rc_keys == NULL || rc_keys_size == NULL) {
                err("af9005_rc_decode function not found, disabling remote");
                af9005_properties.rc_query = NULL;
        } else {
                af9005_properties.rc_key_map = rc_keys;
                af9005_properties.rc_key_map_size = *rc_keys_size; /* <= crash !!! */
        }

        return 0;
}

That line should never run if everything is NULL ..

Daniel

