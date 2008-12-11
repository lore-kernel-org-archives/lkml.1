Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYLKFAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYLKFAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYLKFA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:00:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47072 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYLKFAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:00:25 -0500
Date: Thu, 11 Dec 2008 05:00:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nguyen Anh Quynh <aquynh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
Message-ID: <20081211050023.GM28946@ZenIV.linux.org.uk>
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com> <20081211040118.GK28946@ZenIV.linux.org.uk> <20081210201455.0c611484.akpm@linux-foundation.org> <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 01:23:36PM +0900, Nguyen Anh Quynh wrote:

> So I checked again by fixing the code that should be compiled
> (sound/core/sound.c), and can confirm that without the patch we got
> warning like below:
> 
> sound/core/sound.c: In function 'snd_request_other':
> sound/core/sound.c:91: warning: format not a string literal and no
> format arguments

Ah, but that's different.  Take a look at that warning and think _why_
it is given and what is it about.  Getting an untrusted string as
format argument is a real security hole, but it has nothing to do
with a pile of cases in your patch.

FWIW, even in this case (where the warning is a false positive, BTW -
the string passed there can have one of two values and both are safe)
I would simply do
	switch(...) {
	case .... : request_module("snd-seq"); break;
	case .... : request_module("snd-timer"); break;
	}
and that's it.

Slapping "%s" here actually obfuscates the code, without making it safer.
