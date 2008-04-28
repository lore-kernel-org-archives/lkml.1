Return-Path: <linux-kernel-owner+w=401wt.eu-S1765788AbYD1GqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765788AbYD1GqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbYD1GqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:46:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50130 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbYD1GqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:46:08 -0400
Date: Mon, 28 Apr 2008 08:46:07 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adaplas@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] vt: fix background color on line feed
In-Reply-To: <20080427193616.9a9cdf85.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0804280835370.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr> <20080427193616.9a9cdf85.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-04-28 04:36, Andrew Morton wrote:
>> commit c5180a555ced08a7e3011c16ef796e47569ae907
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Thu Apr 24 22:40:24 2008 +0200
>> 
>> vt: fix background color on line feed
>>     
>> A command that causes a line feed while a background color is active,
>> such as
>>     
>> 	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
>> and
>> 	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
>>     
>> causes the line that was started as a result of the line feed to be
>> completely filled with the currently active background color instead
>> of the default color.
>
>Thanks.
>
>It would be better if the the changelog were to also describe the cause of
>the bug, and how the patch fixes it.
>
Please append:

When scrolling, part of the current screen is memcpy'd/memmove'd to
the new region, and the new line(s) that will appear as a result are
cleared using memset. However, the lines are cleared with
vc->vc_video_erase_char, causing them to be colored with the
currently active background color. This is different from X11
terminal emulators which always paint the new lines with the default
background color (e.g. `xterm -bg black`).

The clear operation (\e[1J and \e[2J) also use vc_video_erase_char,
so a new vc->vc_scrl_erase_char is introduced with contains the erase
character used for scrolling, which is built from vc->vc_def_color
instead of vc->vc_color.
