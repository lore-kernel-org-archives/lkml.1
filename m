Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYHCM0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYHCM0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHCMZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:25:53 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:54944 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYHCMZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:25:52 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linuxppc-dev@ozlabs.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
Date: Mon, 04 Aug 2008 00:25:51 +1200
In-Reply-To: <18581.40960.737792.454035@notabene.brown> (Neil Brown's message
	of "Sun, 3 Aug 2008 22:09:36 +1000")
Message-ID: <87r696l1yo.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> On Sunday August 3, paul@burly.ondioline.org wrote:
>> 
>> I can trigger it reliably with a 2.6.26 client.  I've also triggered it
>> with 496d6c32d4d057cb44272d9bd587ff97d023ee92 reverted on the server.
>> 
>> It's harder to trigger with 2.6.27-rc1+ but I managed to get an Oops
>> on the fourth build after three successful builds on the NFS4 mount.
>> 
>> One of the Oopses I got with 2.6.26 had a slightly different call trace:
>> 
>> Unable to handle kernel paging request for instruction fetch
>> Faulting instruction address: 0x00000000
>
> So we have called a function pointer which was NULL.
>
> There a lots of function pointers in use in this code.
> There is the 'acceptable' function.  There is ->fh_to_dentry
> and ->fh_to_parent.  And various inode operations line ->lookup, but
> that is a bit further away.
>
>> NIP [00000000] 0x0
>> LR [c0159bb0] exportfs_decode_fh+0xa8/0x200
>
> I guess this is where the call came from.
> exportfs_decode_fh is never passed NULL for 'acceptable'.  Only
> ever 'nfsd_acceptable'.
> ->fh_to_parent is tested for NULL before being called, and
> ->fh_to_dentry is called very early in exportfs_decode_fh, where as
> the bad call is 0xa8 in to the function.
>
> Is it possible that ->fh_to_parent is being changed immediately after
> being tested for NULL and before being dereferenced.  That seems
> unlikely.
>
> What filesystem is being exported here?

Boring old ext3 (on LVM, on dm-crypt).

> Can you get an assembly version of exportfs_decode_fh, so we can check
> what is happening at 0xa8 (and 0x4c).

Dump of assembler code for function exportfs_decode_fh:
0xc015b7cc <exportfs_decode_fh+0>:      mflr    r0
0xc015b7d0 <exportfs_decode_fh+4>:      stw     r0,4(r1)
0xc015b7d4 <exportfs_decode_fh+8>:      bl      0xc0013154 <_mcount>
0xc015b7d8 <exportfs_decode_fh+12>:     stwu    r1,-304(r1)
0xc015b7dc <exportfs_decode_fh+16>:     mflr    r0
0xc015b7e0 <exportfs_decode_fh+20>:     stmw    r22,264(r1)
0xc015b7e4 <exportfs_decode_fh+24>:     mr      r27,r3
0xc015b7e8 <exportfs_decode_fh+28>:     mr      r31,r1
0xc015b7ec <exportfs_decode_fh+32>:     stw     r0,308(r1)
0xc015b7f0 <exportfs_decode_fh+36>:     mr      r25,r7
0xc015b7f4 <exportfs_decode_fh+40>:     mr      r26,r8
0xc015b7f8 <exportfs_decode_fh+44>:     mr      r29,r4
0xc015b7fc <exportfs_decode_fh+48>:     mr      r24,r5
0xc015b800 <exportfs_decode_fh+52>:     mr      r23,r6
0xc015b804 <exportfs_decode_fh+56>:     lwz     r3,20(r3)
0xc015b808 <exportfs_decode_fh+60>:     lwz     r30,48(r3)
0xc015b80c <exportfs_decode_fh+64>:     lwz     r0,4(r30)
0xc015b810 <exportfs_decode_fh+68>:     mtctr   r0
0xc015b814 <exportfs_decode_fh+72>:     bctrl
0xc015b818 <exportfs_decode_fh+76>:     mr.     r28,r3
0xc015b81c <exportfs_decode_fh+80>:     bne+    0xc015b824 <exportfs_decode_fh+88>
0xc015b820 <exportfs_decode_fh+84>:     li      r28,-116
0xc015b824 <exportfs_decode_fh+88>:     li      r22,-4096
0xc015b828 <exportfs_decode_fh+92>:     cmplw   cr7,r28,r22
0xc015b82c <exportfs_decode_fh+96>:     bgt-    cr7,0xc015b9b0 <exportfs_decode_fh+484>
0xc015b830 <exportfs_decode_fh+100>:    lwz     r9,8(r28)
0xc015b834 <exportfs_decode_fh+104>:    lhz     r0,114(r9)
0xc015b838 <exportfs_decode_fh+108>:    rlwinm  r0,r0,0,16,19
0xc015b83c <exportfs_decode_fh+112>:    cmpwi   cr7,r0,16384
0xc015b840 <exportfs_decode_fh+116>:    bne-    cr7,0xc015b880 <exportfs_decode_fh+180>
0xc015b844 <exportfs_decode_fh+120>:    lwz     r0,4(r28)
0xc015b848 <exportfs_decode_fh+124>:    andi.   r9,r0,4
0xc015b84c <exportfs_decode_fh+128>:    beq-    0xc015b864 <exportfs_decode_fh+152>
0xc015b850 <exportfs_decode_fh+132>:    mr      r3,r27
0xc015b854 <exportfs_decode_fh+136>:    mr      r4,r28
0xc015b858 <exportfs_decode_fh+140>:    bl      0xc015b45c <reconnect_path>
0xc015b85c <exportfs_decode_fh+144>:    mr.     r30,r3
0xc015b860 <exportfs_decode_fh+148>:    bne-    0xc015b9a4 <exportfs_decode_fh+472>
0xc015b864 <exportfs_decode_fh+152>:    mr      r3,r26
0xc015b868 <exportfs_decode_fh+156>:    mr      r4,r28
0xc015b86c <exportfs_decode_fh+160>:    mtctr   r25
0xc015b870 <exportfs_decode_fh+164>:    bctrl
0xc015b874 <exportfs_decode_fh+168>:    cmpwi   cr7,r3,0
0xc015b878 <exportfs_decode_fh+172>:    beq+    cr7,0xc015b998 <exportfs_decode_fh+460>
0xc015b87c <exportfs_decode_fh+176>:    b       0xc015b9b0 <exportfs_decode_fh+484>
0xc015b880 <exportfs_decode_fh+180>:    mr      r3,r28
0xc015b884 <exportfs_decode_fh+184>:    mr      r4,r25
0xc015b888 <exportfs_decode_fh+188>:    mr      r5,r26
0xc015b88c <exportfs_decode_fh+192>:    bl      0xc015b6c4 <find_acceptable_alias>
0xc015b890 <exportfs_decode_fh+196>:    cmpwi   r3,0
0xc015b894 <exportfs_decode_fh+200>:    bne+    0xc015b990 <exportfs_decode_fh+452>
0xc015b898 <exportfs_decode_fh+204>:    lwz     r0,8(r30)
0xc015b89c <exportfs_decode_fh+208>:    cmpwi   cr7,r0,0
0xc015b8a0 <exportfs_decode_fh+212>:    beq-    cr7,0xc015b9a0 <exportfs_decode_fh+468>
0xc015b8a4 <exportfs_decode_fh+216>:    mr      r4,r29
0xc015b8a8 <exportfs_decode_fh+220>:    mr      r5,r24
0xc015b8ac <exportfs_decode_fh+224>:    lwz     r3,20(r27)
0xc015b8b0 <exportfs_decode_fh+228>:    mtctr   r0
0xc015b8b4 <exportfs_decode_fh+232>:    mr      r6,r23
0xc015b8b8 <exportfs_decode_fh+236>:    bctrl
0xc015b8bc <exportfs_decode_fh+240>:    mr.     r29,r3
0xc015b8c0 <exportfs_decode_fh+244>:    beq-    0xc015b9a0 <exportfs_decode_fh+468>
0xc015b8c4 <exportfs_decode_fh+248>:    cmplw   cr7,r29,r22
0xc015b8c8 <exportfs_decode_fh+252>:    mr      r30,r29
0xc015b8cc <exportfs_decode_fh+256>:    bgt-    cr7,0xc015b9a4 <exportfs_decode_fh+472>
0xc015b8d0 <exportfs_decode_fh+260>:    mr      r3,r27
0xc015b8d4 <exportfs_decode_fh+264>:    mr      r4,r29
0xc015b8d8 <exportfs_decode_fh+268>:    bl      0xc015b45c <reconnect_path>
0xc015b8dc <exportfs_decode_fh+272>:    mr.     r30,r3
0xc015b8e0 <exportfs_decode_fh+276>:    beq-    0xc015b8f0 <exportfs_decode_fh+292>
0xc015b8e4 <exportfs_decode_fh+280>:    mr      r3,r29
0xc015b8e8 <exportfs_decode_fh+284>:    bl      0xc00befb0 <dput>
0xc015b8ec <exportfs_decode_fh+288>:    b       0xc015b9a4 <exportfs_decode_fh+472>
0xc015b8f0 <exportfs_decode_fh+292>:    addi    r30,r31,8
0xc015b8f4 <exportfs_decode_fh+296>:    mr      r3,r27
0xc015b8f8 <exportfs_decode_fh+300>:    mr      r4,r29
0xc015b8fc <exportfs_decode_fh+304>:    mr      r5,r30
0xc015b900 <exportfs_decode_fh+308>:    mr      r6,r28
0xc015b904 <exportfs_decode_fh+312>:    bl      0xc015b2cc <exportfs_get_name>
0xc015b908 <exportfs_decode_fh+316>:    cmpwi   cr7,r3,0
0xc015b90c <exportfs_decode_fh+320>:    bne+    cr7,0xc015b970 <exportfs_decode_fh+420>
0xc015b910 <exportfs_decode_fh+324>:    lwz     r3,8(r29)
0xc015b914 <exportfs_decode_fh+328>:    addi    r3,r3,116
0xc015b918 <exportfs_decode_fh+332>:    bl      0xc0421bb0 <mutex_lock>
0xc015b91c <exportfs_decode_fh+336>:    mr      r3,r30
0xc015b920 <exportfs_decode_fh+340>:    bl      0xc00188fc <strlen>
0xc015b924 <exportfs_decode_fh+344>:    mr      r4,r29
0xc015b928 <exportfs_decode_fh+348>:    mr      r5,r3
0xc015b92c <exportfs_decode_fh+352>:    mr      r3,r30
0xc015b930 <exportfs_decode_fh+356>:    bl      0xc00b4e44 <lookup_one_len>
0xc015b934 <exportfs_decode_fh+360>:    mr      r30,r3
0xc015b938 <exportfs_decode_fh+364>:    lwz     r3,8(r29)
0xc015b93c <exportfs_decode_fh+368>:    addi    r3,r3,116
0xc015b940 <exportfs_decode_fh+372>:    bl      0xc04219a8 <mutex_unlock>
0xc015b944 <exportfs_decode_fh+376>:    cmplw   cr7,r30,r22
0xc015b948 <exportfs_decode_fh+380>:    bgt-    cr7,0xc015b970 <exportfs_decode_fh+420>
0xc015b94c <exportfs_decode_fh+384>:    lwz     r0,8(r30)
0xc015b950 <exportfs_decode_fh+388>:    cmpwi   cr7,r0,0
0xc015b954 <exportfs_decode_fh+392>:    beq-    cr7,0xc015b968 <exportfs_decode_fh+412>
0xc015b958 <exportfs_decode_fh+396>:    mr      r3,r28
0xc015b95c <exportfs_decode_fh+400>:    mr      r28,r30
0xc015b960 <exportfs_decode_fh+404>:    bl      0xc00befb0 <dput>
0xc015b964 <exportfs_decode_fh+408>:    b       0xc015b970 <exportfs_decode_fh+420>
0xc015b968 <exportfs_decode_fh+412>:    mr      r3,r30
0xc015b96c <exportfs_decode_fh+416>:    bl      0xc00befb0 <dput>
0xc015b970 <exportfs_decode_fh+420>:    mr      r3,r29
0xc015b974 <exportfs_decode_fh+424>:    bl      0xc00befb0 <dput>
0xc015b978 <exportfs_decode_fh+428>:    mr      r3,r28
0xc015b97c <exportfs_decode_fh+432>:    mr      r4,r25
0xc015b980 <exportfs_decode_fh+436>:    mr      r5,r26
0xc015b984 <exportfs_decode_fh+440>:    bl      0xc015b6c4 <find_acceptable_alias>
0xc015b988 <exportfs_decode_fh+444>:    cmpwi   r3,0
0xc015b98c <exportfs_decode_fh+448>:    beq-    0xc015b998 <exportfs_decode_fh+460>
0xc015b990 <exportfs_decode_fh+452>:    mr      r28,r3
0xc015b994 <exportfs_decode_fh+456>:    b       0xc015b9b0 <exportfs_decode_fh+484>
0xc015b998 <exportfs_decode_fh+460>:    li      r30,-13
0xc015b99c <exportfs_decode_fh+464>:    b       0xc015b9a4 <exportfs_decode_fh+472>
0xc015b9a0 <exportfs_decode_fh+468>:    li      r30,-116
0xc015b9a4 <exportfs_decode_fh+472>:    mr      r3,r28
0xc015b9a8 <exportfs_decode_fh+476>:    mr      r28,r30
0xc015b9ac <exportfs_decode_fh+480>:    bl      0xc00befb0 <dput>
0xc015b9b0 <exportfs_decode_fh+484>:    lwz     r11,0(r1)
0xc015b9b4 <exportfs_decode_fh+488>:    mr      r3,r28
0xc015b9b8 <exportfs_decode_fh+492>:    lwz     r0,4(r11)
0xc015b9bc <exportfs_decode_fh+496>:    lmw     r22,-40(r11)
0xc015b9c0 <exportfs_decode_fh+500>:    mr      r1,r11
0xc015b9c4 <exportfs_decode_fh+504>:    mtlr    r0
0xc015b9c8 <exportfs_decode_fh+508>:    blr
End of assembler dump.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
