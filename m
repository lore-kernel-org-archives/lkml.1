Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BAMyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:54:55 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64402 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0BAMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mEiZgq/BsJHq5/f/xMOnPU3/KKhwkZgfjb4eXe8uWCY48Iuab2NzeSGI72K0Ms2SvN
         ulaePJiN7ks8SEylmllGumt9b/pLn4E9YKzUWgqQpgiwxZFIgtpaZ+2k+4/J0aEOVzOi
         T/gTEDsdGf287+Bpf2qFIueaXTH7+iE5DQXKU=
Date: Mon, 1 Feb 2010 15:54:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux1394-devel@lists.sourceforge.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error
	ffffffff810251b5 cr2 0
Message-ID: <20100201125441.GB2576@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	linux1394-devel@lists.sourceforge.net,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6630CA.9010207@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 05:39:22PM -0800, Justin P. Mattock wrote:
> On 01/31/10 16:43, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.31 and 2.6.32.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
>> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
>> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
>> Date		: 2009-10-23 16:45 (101 days old)
>> References	: http://lkml.org/lkml/2009/10/23/252
>>
>>
>>
>
>
> yeah still hitting this.
> looking at the issue if I change:
>
> @@ 260
>
> if ((class == 0xffffffff))
> 	continue;
> to
>
> if ((class == 0xffffffff || 0xffffffffffffffff))
> 	continue;
>

Uh... 0xffffffffffffffff is always true so basically that's the same as deleting the
if condition.

I've added the linux1394-devel people to the CC list.

Justin has found an issue that when he boots with:  ohci1394_dma=early his computer
crashes.

He can get it to boot by modifying drivers/ieee1394/init_ohci1394_dma.c:

init_ohci1394_dma_on_all_controllers()
   254          /* Poor man's PCI discovery, the only thing we can do at early boot */
   255          for (num = 0; num < 32; num++) {
   256                  for (slot = 0; slot < 32; slot++) {
   257                          for (func = 0; func < 8; func++) {
   258                                  u32 class = read_pci_config(num,slot,func,
   259                                                          PCI_CLASS_REVISION);
   260                                  if ((class == 0xffffffff))
   261                                          continue; /* No device at this func */

	If he continues here then his system boots.

   262
   263                                  if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
   264                                          continue; /* Not an OHCI-1394 device */
   265
   266                                  init_ohci1394_controller(num, slot, func);
   267                                  break; /* Assume one controller per device */

	This comment is not terribly clear btw.  The code assumes one controller per slot.

   268                          }
   269                  }
   270          }

regards,
dan carpenter


> I'm able to boot, but don't have enough knowledge to know
> what is really happening(or how to execute this).
> will continue looking at this
> (hopefully I get somewhere on this);
>
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
