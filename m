Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZIKLhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZIKLhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZIKLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:37:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZIKLhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:37:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
Date: Fri, 11 Sep 2009 13:34:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <1252668148.7126.13.camel@laptop>
In-Reply-To: <1252668148.7126.13.camel@laptop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909111334.45241.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/aDTr1seYM2pUOK96t8MRgIZ7XHN3Lk8IhleG
 9OXFxnw8/fDXTRChMG+DHruSGIyfoU5qXGG9MG9nL0ROyqKuw2
 qhuswov6iaQZAW/iKVnNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, Peter Zijlstra wrote:
> Why not have something like:
> 
> struct clone_struct {
>         u32 size;
>         u32 __reserved;
>         u64 flags;
>         u64 child_stack;
>         u32 child_tid;
>         u32 parent_tid;
> };
> 
> struct clone_pid_struct {
>         u32 nr;
>         pid_t pids[];
> };
> 
> int clone2(struct clone_struct *cs, struct clone_pid_struct *cps);
> 
> If you then get passed a longer clone_struct than you know about, all is
> well IFF the tail is 0, otherwise fail with -E2BIG.
> 
> If you get passed a short clone_struct, zero out the tail.

I would leave out the size argument. We can put a few reserved fields
and flag bits in there for possible extensions, but if we ever run out
of these, just define a new syscall.

Also, if you're passing a struct, why not put nr_pids in there, and
replace clone_pid_struct with a simple array? That would give us

struct clone_struct {
        u64 flags;
        u64 child_stack;
        u32 child_tid;
        u32 parent_tid;
	u32 nr_pids;
	u32 reserved1;
	u64 reserved2;
};
 
int clone2(struct clone_struct *cs, pid_t *pids);

	Arnd <><
