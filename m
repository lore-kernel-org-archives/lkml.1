Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbYBZWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbYBZWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYBZWX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:26 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2812 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753284AbYBZWXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:25 -0500
Date: Tue, 26 Feb 2008 23:23:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, i2c@lm-sensors.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
Message-ID: <20080226232320.2df756d6@hyperion.delvare>
In-Reply-To: <20080226210307.GA6085@joi>
References: <20080225205055.GA27455@joi>
	<20080226133222.7af260b2@hyperion.delvare>
	<20080226210307.GA6085@joi>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcin,

On Tue, 26 Feb 2008 22:03:16 +0100, Marcin Slusarz wrote:
> Do you have an idea (or patch :D) how to solve this:
> 0x00000234 v4l_compat_translate_ioctl [v4l1-compat]:    1376
> ? That's on top of my make checkstack output

Random ideas (but I am in no way a specialist of this exercise):

* You could try moving the structures to the blocks where they are used,
in the case a given structure is used for only one ioctl. I'm not too
sure how gcc handles local variables declared inside blocks with
regards to stack reservation though. I thought it would work but my
experiments today seem to suggest it doesn't.

* You can move the handling of some ioctls to dedicated functions, just
like I did in i2c-dev:
http://lists.lm-sensors.org/pipermail/i2c/2008-February/003010.html
However there is a risk that gcc will inline these functions (that's
what happened to me...) Not sure how to prevent gcc from inlining.

* You can allocate the structures dynamically, as you originally wanted
to do for ir-kbd-i2c. However this has a performance penalty and will
fragment the memory, so it's not ideal.

* If each ioctl uses only one of the structures, you may define a union
of all the structures. The size of the union will be the size of the
biggest structure, so you save a lot of space on the stack.

-- 
Jean Delvare
