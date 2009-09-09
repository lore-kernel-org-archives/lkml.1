Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbZIIMVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbZIIMVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZIIMVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:21:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62822 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZIIMVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:21:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nathan Lynch <ntl@pobox.com>
Subject: Re: [RFC][v5][PATCH 8/8]: Define clone_with_pids() syscall
Date: Wed, 9 Sep 2009 14:19:50 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
References: <20090907211302.GA5892@us.ibm.com> <20090907211700.GH6685@us.ibm.com> <m3zl95l2oz.fsf@pobox.com>
In-Reply-To: <m3zl95l2oz.fsf@pobox.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909091419.50496.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/U/cpFVumXmQDi2n8C4CVbxOhYiUFDSDAAfJd
 Fl81LbvbygG4S9GohuNy2ggvzI5RRBG0dVIiVMiA8uoWM2X1HR
 Q6jSrzTcOB0u2Yir1ixlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, Nathan Lynch wrote:

> This doesn't work on a 64-bit kernel when the process is 32-bit and uses
> the definition of struct pid_set provided in types.h:
> 
> +struct pid_set {
> +       int num_pids;
> +       pid_t *pids;
> +};
> 
> Shouldn't the pids field be u64 or some other type of fixed size?

This is a complex problem. The structure above would need a conversion
for the pointer size that you can avoid by using a u64, but that introduces
another problem:

struct pid_set {
	int num_pids;
	u64 pidp;
};

Has implicit padding between the two members on all 64 bit architectures,
but not on i386, so you would still need a conversion (not for s390, power,
mips, sparc or parisc though, only for x86).

I can see two solutions for this:

1. use separate system call arguments for num_pids and pidp.
This avoids the data structure and saves one copy_from_user call,
at the cost of adding another argument to the syscall. syscalls with
more than 6 arguments are somewhat problematic as well.

2. use a single pointer, with variable length data structures:

struct pid_set {
	int num_pids;
	pid_t pids[0];
};

Since pid_t is always an int, you have no problem with padding or
incompatible types, but rely on a data structure definition that
is not in C89 (not sure about C99).

	Arnd <><
