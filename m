Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYHSOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYHSOY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYHSOYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:24:16 -0400
Received: from smtp.extricom.com ([192.114.46.18]:35689 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751545AbYHSOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:24:15 -0400
Message-ID: <48AAD702.10700@extricom.com>
Date: Tue, 19 Aug 2008 17:21:54 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
References: <48591941.4070408@extricom.com> <48A92E15.2080709@extricom.com> <48A9901B.1080900@redhat.com> <48A9BEA3.10906@extricom.com> <alpine.DEB.1.10.0808181439480.796@gandalf.stny.rr.com> <48AAB7FF.4070502@extricom.com> <20080819130533.GA18611@Krystal>
In-Reply-To: <20080819130533.GA18611@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Can you also give us
>
> objdump -S --start-address=0xC00BB724 vmlinux | head 20
>
> ?
>
> Then we could compare the result with the OOPS instruction dump :
>
> 7c0802a6 bf61000c 3f60c038 7c3f0b78 90010024 7c7c1b78 7c9d2378 83db32a0
> 73c00001 7f83e378 7fa4eb78 4082002f <00000000> 2f830000 409e0030 801b32a0
>
> Mathieu
>
>   

to give you more context I have run:
 > powerpc-linux-gnu-objdump -S --start-address=0xC00BB700 vmlinux | 
head -n 60

the discrepancy starts at address:
c00bb720: 40 82 00 30 <=> 40 82 00 2f
c00bb724: 4b ff fe 61 <=> 00 00 00 00

vmlinux:     file format elf32-powerpc

Disassembly of section .text:

c00bb700 <d_lookup+0x1c>:
 * d_lookup() is protected against the concurrent renames in some unrelated
 * directory using the seqlockt_t rename_lock.
 */

struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
{
c00bb700:       7c 3f 0b 78     mr      r31,r1
c00bb704:       90 01 00 24     stw     r0,36(r1)
c00bb708:       7c 7c 1b 78     mr      r28,r3
c00bb70c:       7c 9d 23 78     mr      r29,r4
c00bb710:       83 db 32 a0     lwz     r30,12960(r27)
{
        unsigned ret;

repeat:
        ret = sl->sequence;
        smp_rmb();
c00bb714:       73 c0 00 01     andi.   r0,r30,1
        struct dentry * dentry = NULL;
        unsigned long seq;

        do {
                seq = read_seqbegin(&rename_lock);
                dentry = __d_lookup(parent, name);
c00bb718:       7f 83 e3 78     mr      r3,r28
c00bb71c:       7f a4 eb 78     mr      r4,r29
        if (unlikely(ret & 1)) {
c00bb720:       40 82 00 30     bne-    c00bb750 <d_lookup+0x6c>
c00bb724:       4b ff fe 61     bl      c00bb584 <__d_lookup>
                if (dentry)
c00bb728:       2f 83 00 00     cmpwi   cr7,r3,0
c00bb72c:       40 9e 00 30     bne-    cr7,c00bb75c <d_lookup+0x78>
 *
 * If sequence value changed then writer changed data while in section.
 */
static __always_inline int read_seqretry(const seqlock_t *sl, unsigned 
start)
{
        smp_rmb();
c00bb730:       80 1b 32 a0     lwz     r0,12960(r27)
                        break;
        } while (read_seqretry(&rename_lock, seq));
c00bb734:       7f 80 f0 00     cmpw    cr7,r0,r30
c00bb738:       41 9e 00 24     beq-    cr7,c00bb75c <d_lookup+0x78>
/* Start of read calculation -- fetch last complete writer token */
static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
{
        unsigned ret;

repeat:
c00bb73c:       7c 1e 03 78     mr      r30,r0
        ret = sl->sequence;
        smp_rmb();
c00bb740:       73 c0 00 01     andi.   r0,r30,1
        struct dentry * dentry = NULL;

