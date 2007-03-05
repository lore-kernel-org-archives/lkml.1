Return-Path: <linux-kernel-owner+w=401wt.eu-S1751131AbXCEBDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbXCEBDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXCEBDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:03:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:62073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXCEBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:03:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, michael@ellerman.id.au
Subject: Re: [Cbe-oss-dev] [PATCH 14/22] spufs: use SPU master control =?iso-8859-15?q?to=09prevent_wild=09SPU?= execution
Date: Mon, 5 Mar 2007 02:02:59 +0100
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20061120174454.067872000@arndb.de> <200703011450.50935.arnd@arndb.de> <1172830438.16533.6.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1172830438.16533.6.camel@concordia.ozlabs.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050202.59596.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18UQ7Egn5zPo6OPQJVFZwiusHVjx00fs8F7szM
 V6yAebfb9eaqXM4j+A7JtG82OAJhSfmI/9lAOAHlCPBqpS6s1C
 LJJ6RI6CcGThXjpaVtjSA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007, Michael Ellerman wrote:
> There's also the error case for spu_run_init() which skips the master
> stop. I guess that's ok because we've only set the master control in the
> backing store, and the only way that will ever get propagated to an
> actual spu is by coming back thorough spufs_run_spu().

Hmm, the correct way would be to switch off the master control in there,
afaics. Fixing it only in spu_run_init would mean that we also handle
the case of spu_reacquire_runnable along with it.

> What originally caught my eye on this was the output from xmon. When we
> drop into xmon with no spu programs running and stop the spus, it
> reports that they _all_ have the master run enabled,

That looks right, there is no problem to have master control enabled,
as long as user space can't access the spu through a context that is
bound to it.

> and some of them 
> have the runcntl enabled (those that have had spu programs run on them
> since boot it seems).

While this sounds wrong. Maybe the runcntl is active on those that have
_not_ run since boot, which would make more sense. We should investigate
this.

> It looks like the save/restore code sets the master bit in several
> places, but never sets/clears the runcntl, which seems bogus to me.
> 
> So when we leave spufs_spu_run we do the master stop call:
> 
> spu_mfc_sr1_set: spu: c00000007ffdfc80 (15) sr1: 0x1b runcntl: 0x1
> Call Trace:
> [C00000000196BAA0] [C00000000000F920] .show_stack+0x68/0x1b0 (unreliable)
> [C00000000196BB40] [D0000000001475C0] .spu_hw_master_stop+0xa8/0x170 [spufs]
> [C00000000196BBE0] [D000000000148598] .spufs_run_spu+0x5ec/0x770 [spufs]
> [C00000000196BCC0] [D000000000144BA0] .do_spu_run+0xb4/0x180 [spufs]
> [C00000000196BD80] [C00000000003905C] .sys_spu_run+0xb0/0x108
> [C00000000196BE30] [C000000000008634] syscall_exit+0x0/0x40
> 
> 
> But then the save/restore code sets it back on?

Right, the context save code needs to enable master control in order to
run on the spu. However, that should be after all mappings to user space
have been discarded.

	Arnd <><
