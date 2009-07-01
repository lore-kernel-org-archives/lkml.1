Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZGANmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZGANmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZGANmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:42:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZGANmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:42:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic header files for the ABI
Date: Wed, 1 Jul 2009 15:41:55 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <cover.1245345894.git.arnd@arndb.de> <200907011342.26669.arnd@arndb.de> <4A4B5213.9060003@monstr.eu>
In-Reply-To: <4A4B5213.9060003@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907011541.56225.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/tbLRFSAl520VUapL4T5tvOb/RADXjXeYR5rY
 zJkjh3xLNHfSZUC4FfEcO4Pw+jNBaModKq1Jw2F3L5wRnjK5H1
 LXMsof8QSJRa3LmXRtPyTbopo4lP7bK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Michal Simek wrote:
> I did this change because of problem with inconsistency between kernel/glibc.
> 
> Current our glibc ipc_perm struct - mode is short - that's why I have setup kernel_mode_t to short too.
> 
> /* Data structure used to pass permission information to IPC operations.  */
> struct ipc_perm
>   {
>     __key_t __key;                      /* Key.  */
>     __uid_t uid;                        /* Owner's user ID.  */
>     __gid_t gid;                        /* Owner's group ID.  */
>     __uid_t cuid;                       /* Creator's user ID.  */
>     __gid_t cgid;                       /* Creator's group ID.  */
>     unsigned short int mode;            /* Read/write permission.  */
>     unsigned short int __seq;           /* Sequence number.  */
>     unsigned short int __pad1;
>     unsigned long int __unused1;
>     unsigned long int __unused2;
>   };
> 
> Does it make more sense to define it as int?

It's more complex than this.

AFAICT, it does not matter at all whether you define it as 16 or 32 bits,
as long as it all fits together. For the generic ABI, I used 32 bits where
they were commonly used by some architectures, because there are processors
that can more efficiently access 32 bit words than 16 bit words.

One major reason for starting the asm-generic ABI definitions was to make
sure that all architectures that don't have their ABI set in stone can
use the exact same ABI, and if you change just a small thing, you would still
diverge from the common ABI.

Now the definition you give above matches neither the one from your current
kernel header nor the one from the asm-generic file, because of the location
of the padding. Worse, the __pad1 field actually causes implicit padding instead
of preventing it.

I think you should just update your glibc files to match the generic kernel
headers, because changing the ABI means that you have to change other parts
of glibc anyway and to recompile every single user space program anyway.
Doing one more change won't hurt that much either.

	Arnd <><
