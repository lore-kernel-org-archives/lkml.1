Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYKRRmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYKRRmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYKRRmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:42:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:47013 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYKRRl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gfc8lfUNA85r3QgXEvrLEs27DfsTNXDaJBl8Jc2gn2ZL8tvOL7efn3kJFyTQKRo+MM
         olb3yoaaYf3SwO1ewqZ2qeoRFD34wacQYbP68mwC+LRKoDUpGBYg9x5Z8WSkKKlHwTVG
         rU75r3pqT2o1WWtoFLdHpD8s8R57oP+9jTqNg=
Subject: Re: [ 11.333737] is this a ghost?
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <4922F441.7020007@tuffmail.co.uk>
References: <1227001038.3184.6.camel@LiNuX>
	 <9b2b86520811180315u410019f0y7e6fab66b51a225e@mail.gmail.com>
	 <1227025771.3161.6.camel@LiNuX>  <4922F441.7020007@tuffmail.co.uk>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 09:41:54 -0800
Message-Id: <1227030114.3161.18.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 16:58 +0000, Alan Jenkins wrote:
> Justin P. Mattock wrote:
> > On Tue, 2008-11-18 at 11:15 +0000, Alan Jenkins wrote:
> >   
> >> On 11/18/08, Justin P. Mattock <justinmattock@gmail.com> wrote:
> >>     
> >>> in dmesg I see:
> >>> [   11.333737]
> >>> but nothing else.
> >>>           ---------------(cut)-----------------
> >>> [   11.247147] Monitor-Mwait will be used to enter C-1 state
> >>> [   11.247151] Monitor-Mwait will be used to enter C-2 state
> >>> [   11.247154] Monitor-Mwait will be used to enter C-3 state
> >>> [   11.247671] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> >>> [   11.247996] processor ACPI_CPU:00: registered as cooling_device0
> >>> [   11.248008] ACPI: Processor [CPU0] (supports 8 throttling states)
> >>> [   11.306465] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
> >>> INTL 20050309)<7>power_supply ADP1: No power supply yet
> >>>       
> >> Look at this last line.  The "<7>" is a priority marker.  Normally it
> >> marks the start of a line, and should be hidden.  So you seem to be
> >> missing a line break just after "20050309)"...
> >>
> >>     
> >>> [   11.306831] power_supply ADP1: power_supply_changed
> >>> [   11.306839] ACPI: AC Adapter [ADP1] (on-line)
> >>> [   11.333737]                         <------------what's with this!!!
> >>>       
> >> ...which seems to be delayed and reappears here?
> >>
> >>     
> >>> [   11.342937] power_supply ADP1: power_supply_changed_work
> >>> [   11.351901] power_supply ADP1: power_supply_update_gen_leds 1
> >>> [   11.351916] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
> >>> INTL 20050309)
> >>>       
> >>> if you need to see the full dmesg I can attach..
> >>> I've seen this happen on a random.
> >>>       
> >> I guess you have a multicore processor (or some other sort of SMP), right?
> >>
> >> I think kernel messages are not completely synchronized by design, for
> >> reliability reasons.  (e.g. to make sure critical error messages /
> >> backtraces can get through on a dying system).
> >>     
> >
> >
> > Cool.
> > makes good sense to me, 
> > As long as it's not something that shouldn't be there,
> > or something that's broken. As for this happening again
> > looking at dmesg nothing, all synchronized.
> > Seems to randomly show itself.
> >   
> 
> It's the ACPICA OS abstraction layer - it splits every message into
> multiple printk() calls.  Other subsystems don't do this... it probably
> could and should be fixed.
> 
> drivers/acpi/utmisc.c:
> 
>     void ACPI_INTERNAL_VAR_XFACE
>     acpi_ut_info(const char *module_name, u32 line_number, const char
>     *format, ...)
>     {
>         va_list args;
> 
>         /*
>          * Removed module_name, line_number, and acpica version, not needed
>          * for info output
>          */
>         acpi_os_printf("ACPI: ");
> 
>         va_start(args, format);
>         acpi_os_vprintf(format, args);
>         acpi_os_printf("\n");
>         va_end(args);
>     }
> 
> The alternative is to use the preprocessor, i.e. macros and string
> concatenation to generate a single printk().
> 
> Alan

Maybe I'm missing a library or something.
The issue with this is the consistency.
one reboot I'll see it up higher in dmesg,
and then on another reboot nothing, then
maybe a few more reboots I'll see it down lower
in dmesg(like what I posted). As for fixing this
I'm not educated enough to go in and exactly know what
to change(one day hopefully, so I can contribute),
But I am willing to try a patch out to see if it resolves
the issue. 

regards;

-- 
Justin P. Mattock <justinmattock@gmail.com>

