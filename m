Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYJMSIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYJMSIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYJMSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:08:29 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:45532 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbYJMSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:08:28 -0400
Message-ID: <48F38E95.4090103@control.lth.se>
Date: Mon, 13 Oct 2008 20:08:21 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
References: <48EF6762.2080205@control.lth.se>	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>	<48EF7949.4010108@control.lth.se>	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>	<48F32899.5000006@control.lth.se>	<20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>	<48F3473E.6070305@control.lth.se>	<20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>	<48F35F50.3000704@control.lth.se>	<20081013172852.393584be@hskinnemo-gx745.norway.atmel.com>	<48F37707.8040401@control.lth.se> <20081013191534.7cbeebc1@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081013191534.7cbeebc1@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped the kernel list CC on previous post, sorry.

Haavard Skinnemoen wrote:
> Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>>>> I see a distinct clutter in setup.c (#ifndef CONFIG_BOARD_ATNGW100_EVKLCD10X)
>>>> :-) (it clearly shows the need for conflict resolution, though)  
>>> Yes, but it's hard to avoid that, it's confined to the support code
>>> for that particular expansion board, and the clutter is there to
>>> support actual variations of the board. It could have been moved into
>>> separate files, but that would have led to more duplication.  
>> Nope, it's right in the setup.c file.
>>
>>> It's all about finding the right balance, really.
>>>
>>> I didn't quite understand what you mean by "conflict resolution".  
>> That .detect_pin and .wp_pin conflicts with the LCD (so the #ifdef disables them)
> 
> Oh, that stuff. Yeah, when an expansion board needs to disable features
> on the motherboard, it gets a bit messy.
How should this be handled with device tree?

>>> But is wading through several dozen config options really that much
>>> easier than writing ten lines of code?  
>> Nope, but if there are changes in some kernel code, local changes can easily get
>> out of sync.
> 
> That's why you should send it upstream so that it can be kept in sync
> whenever something changes. Also note that the same applies to your
> out-of-tree module.
Which is what I'm trying to do, but the maintainer is complaining :-)
But we probably don't want to add everyones prototype boards to the kernel tree!

>>>> Question is if there is any way to come up with a solution that makes it
>>>> possible to select software modules for what is present on a specific expansion
>>>> board, my naive thought was that it should be selected by Kconfig (and in that
>>>> vein, my 5 cents is that video for ngw100/stk100x should be selected as
>>>> TCG057QVLAD/PH320240T/LTV350QV, and not as a by-product of selecting a specific
>>>> expansion board, this way it would be easier to add video to a custom expansion
>>>> board withou dragging in unrelated functions like USARTs). Perhaps it is
>>>> possible to solve my problems as well as the stk100x clutter if it is done right?  
>>> Possibly. But adding options for the USARTs is only solving a tiny part
>>> of the problem, and I'm worried that solving the rest in the same
>>> manner is going to end up as a spectacular mess. If you can prove me
>>> wrong, I'm all for it.  
>> It's not about proving either me or you wrong, it's about making this easy to do
>> for everybody (not only me, I can live with modifying the kernel tree), if it is
>> not possible, so be it.
> 
> I'm asserting that doing this kind of board customization through
> Kconfig is going to get messy once we support enough features to make
> everyone happy. If you can show that it can be done in a clean way,
> i.e. prove me wrong, nothing would make me happier.
> 
> But I do think device trees along with a nice graphical editor, or a
> few u-boot commands, would go a long way towards this goal. If we
> manage to get something like that working, you won't even have to
> recompile anything.
As far as I can see, the device trees will push the conflict resolution to
run-time instead of compile-time, which I belive is bad for both memory
footprint as well as performance (as well as predictability, this kernel worked
yesterday; who added which device which makes it crash today...)

>> But personally I would be happy with a generic ap7000
>> board, where I could pick all the options I like and the ngw100 and stk100x
>> would just be an instance of this board with all/most options preselected. That
>> #ifdefs are messy to read is something we agree about...
> 
> Right, I also want more generic board support. But I don't think
> Kconfig is the way to go. There are just too many variables.
Wouldn't there be as many variables with a device tree?

A graphical board-configurator against the Kconfig should certainly be possible?

I'm also not (yet) convinced that your approach makes the configuration any simpler.

How about putting each needed extension in a separate file (with a specified
format), and use some kind of preprocessor to generate Kconfig's, Makefiles,
setup.c, etc from those files (and generating the appropriate at32_reserve_*,
at32_select* as well). I.e. something like:

USART2.def:

%PINS {
  PA08, PA09
}

%GLOBAL {
  platform device *usart2;
}

%INIT {
  usart2 = at32_add_device_usart(2);
}

%SETUP {
  new_at32_map_usart(usart2, at_32_last_mapped_usart++);
}

/Anders

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
