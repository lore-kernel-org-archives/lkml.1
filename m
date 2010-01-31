Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610Ab0AaEaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0AaEaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 23:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082Ab0AaEav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 23:30:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0AaEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 23:30:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
Date: Sun, 31 Jan 2010 05:20:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com> <201001302257.09354.arnd@arndb.de> <520f0cf11001301507k20e3cf8dqa73026e12f3a1767@mail.gmail.com>
In-Reply-To: <520f0cf11001301507k20e3cf8dqa73026e12f3a1767@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001310520.55813.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ph3d+aEF0WbaDFs4gCft/2JscjDdtL41KqvX
 YkgaX3gAcSmg9FSz6h+or072DO1lmrxUG0zcq30LooQtVJDEZc
 Y0tY0jjSsYBDXzFFvx/nA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 January 2010, John Kacur wrote:
> > Sorry, I should have been clearer, but not implementing llseek
> > is the problem I was referring to: When a driver has no explicit
> > .llseek operation in its file operations and does not call
> > nonseekable_open from its open operation, the VFS layer will
> > implicitly use default_llseek, which takes the BKL. We're
> > in the process of changing drivers not to do this, one by one
> > so we can kill the BKL in the end.
> >
> 
> I know we've discussed this before, but why wouldn't the following
> make more sense?
>  .llseek         = no_llseek,

That's one of the possible solutions. Assigning it to generic_file_llseek
also gets rid of the BKL but keeps the current behaviour (calling seek
returns success without having an effect, no_llseek returns -ESPIPE),
while calling nonseekable_open has the other side-effect of making
pread/pwrite fail with -ESPIPE, which is more consistent than
only failing seek.

	Arnd

