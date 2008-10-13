Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYJMOrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYJMOrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYJMOqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:46:55 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:58907 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYJMOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:46:54 -0400
Message-ID: <48F35F50.3000704@control.lth.se>
Date: Mon, 13 Oct 2008 16:46:40 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
References: <48EF6762.2080205@control.lth.se>	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>	<48EF7949.4010108@control.lth.se>	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>	<48F32899.5000006@control.lth.se>	<20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>	<48F3473E.6070305@control.lth.se> <20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>> Haavard Skinnemoen wrote:
>>> Adding EXPORT_SYMBOLs purely for use by out-of-tree modules is
>>> generally frowned upon. 
>> If I'm not mistaken, you need EXPORT_SYMBOL for any loadable module, be it in-
>> or out-of-tree.
> 
> Yes, but no in-kernel modules need those symbols exported.
No, that's right.

>>> And patching in an additional file to the build is just about the easiest
>>> thing you can do.
>> Next to config options and loadable modules out-of-tree :-)
> 
> Really? I personally think out-of-tree modules is a real hassle causing
> extra work each time I need to update the kernel, whether it's on my
> embedded target or my PC.
Depends on if it's you or somebody else (who doesn't care about your code) that
rebuilds the kernel. Since I plan to use some tens of atngw100's eventually,
with at least 3 different expansions boards, a solution that doesn't need 3
different kernels (i.e. loadable modules) is much preferred to a Kconfig (I know
I started out with this, but one does change opinion :-) occasionally) or
in-tree init code.

> On the other hand, a trivial patch adding support for an expansion
> board can just stay in your tree while you do a 'git pull' to grab the
> most up-to-date kernel.
> 
> Even better, if you send your trivial patch upstream, it will just be
> there the next time you update your kernel. No need to do anything
> extra at all.
> 
> A Kconfig option is admittedly just as easy, but with the added
> downside that it makes the board code less readable, and there will
> never be enough of them to support every board mod that people make.
> 
>>>>> What _I_ think would be a nicer way to do it is to implement support
>>>>> for flattened device trees and get rid of the board code entirely. Or
>>>>> almost entirely; it depends on how complete we can make the device tree.
>>>> I don't understand the above paragraph, could you please elaborate?
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/powerpc/booting-without-of.txt;h=de4063cb4fdc0ad6abea29d766cae78616837311;hb=HEAD
>> OK, essentially compile all drivers into the kernel and let the boot-loader tell
>> us what to activate. Gives a small kernel bloat (which I can live with), but
>> what if two conflicting drivers (e.g. same I/O pin) are selected by the
>> flattened tree?
> 
> That's how it works today, except that it's the board code which
> specifies what to activate instead of the boot loader (or a device tree
> blob in flash.) So there won't be any additional bloat unless you
> go and select lots of drivers you don't need.
> 
> On the other hand, these functions are currently __init, so if we
> export them for use by modules, it will definitely bloat the kernel.
> 
>> But I take your replies that you are adamantly against kernel options for the
>> atngw100, so I'll drop the subject for now (letting everyone figure out their
>> favorite way to configure modified boards).
> 
> I'm not fundamentally against kernel options for the atngw100. I just
> don't like cluttering up the board code.
> 
> If you add support for an expansion board, you'll definitely need a
> config option to select it as well. But that option is only used to
> select the implementation file for that board; it won't add any
> additional mess to the core NGW100 code.
> 
> Have a look at the EVKLCD10x code that was just applied for an example
> of how to add support for an expansion board:
> 
> http://git.kernel.org/?p=linux/kernel/git/hskinnemoen/avr32-2.6.git;a=commitdiff;h=a3bee42f058c2f9fe281df942eff397924630a12
> 
> Most of it is LCD-related, so if you only need to add a USART, you'll
> only need a fraction of the code.
I see a distinct clutter in setup.c (#ifndef CONFIG_BOARD_ATNGW100_EVKLCD10X)
:-) (it clearly shows the need for conflict resolution, though)

> Also note that it shows a huge problem with the Kconfig approach: Most
> devices need additional board-specific data. And even though the USART
> doesn't currently need any of that, it may in the future when we add
> support for RS485, hardware flow control, etc. How will you deal with
> that through Kconfig?
Honestly, I don't know :-(, but it would be nice to be able to select all these
options wihout having to write the code myself :-)

Question is if there is any way to come up with a solution that makes it
possible to select software modules for what is present on a specific expansion
board, my naive thought was that it should be selected by Kconfig (and in that
vein, my 5 cents is that video for ngw100/stk100x should be selected as
TCG057QVLAD/PH320240T/LTV350QV, and not as a by-product of selecting a specific
expansion board, this way it would be easier to add video to a custom expansion
board withou dragging in unrelated functions like USARTs). Perhaps it is
possible to solve my problems as well as the stk100x clutter if it is done right?

Regards

Anders

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
