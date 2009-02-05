Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbZBEBMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbZBEBMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbZBEBMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:12:13 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:61697 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757477AbZBEBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:12:12 -0500
Date: Thu, 5 Feb 2009 04:12:04 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090205011204.GA25628@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150838.GB30027@oksana.dev.rtsoft.ru> <1233793889.4612.33.camel@pasglop> <1233794154.16878.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233794154.16878.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 07:35:54PM -0500, Steven Rostedt wrote:
> 
> On Thu, 2009-02-05 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2009-02-04 at 18:08 +0300, Anton Vorontsov wrote:
> > > Remove -fno-omit-frame-pointer flag from CFLAGS.
> > > Remove -fno-omit-frame-pointer workarounds.
> > 
> > But what about -pg -requires -fno-omit-frame-pointer ?
> 
> I don't think it requires -fno-omit-frame-pointer. It is just
> incompatible with -fomit-frame-pointer.

Yep, -fno-omit-frame-poiner isn't needed for -pg.

I explained this in http://lkml.org/lkml/2009/2/3/342 :

| Ah...
|
| $ gcc -pg -fomit-frame-pointer -S c.c
| gcc: -pg and -fomit-frame-pointer are incompatible
|
| It's hard-coded in gcc, in the code that don't know about
| architecture details.
|
| But on PowerPC -O1 implies -fomit-frame-pointer, that is
|
| gcc -pg -O1 -fno-omit-frame-pointer
| and
| gcc -pg -O1
|
| produce different outputs. Thus -pg -O should be the same
| as "-pg -O -fomit-framepointer".

That is,

`gcc -O -pg -fno-omit-frame-pointer -S` output:

main:
        mflr 0
        stw 0,4(1)
        bl _mcount
        stwu 1,-16(1)
        mflr 0
        stw 0,20(1)
        stw 31,12(1)
        mr 31,1
        li 3,0
        lwz 11,0(1)
        lwz 0,4(11)
        mtlr 0
        lwz 31,-4(11)
        mr 1,11
        blr

^^ -pg works (_mcount call), but r31 wasted.

Now `gcc -O -pg -S` output:

main:
        mflr 0
        stw 0,4(1)
        bl _mcount
        stwu 1,-16(1)
        mflr 0
        stw 0,20(1)
        li 3,0
        lwz 0,20(1)
        mtlr 0
        addi 1,1,16
        blr

^^ _mcount is still there, and r31 isn't used.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
