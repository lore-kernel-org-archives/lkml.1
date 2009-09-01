Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZIALkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZIALkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZIALkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:40:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbZIALkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:40:00 -0400
Date: Tue, 1 Sep 2009 13:39:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org
Subject: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901113914.GA23578@elte.hu>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901100351.GA3361@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, -tip testing found a nasty bootup crash:
> 
> [    0.027010] Checking 'hlt' instruction... OK.
> [    0.034023] calling  spawn_ksoftirqd+0x0/0x48 @ 1
> [    0.035025] BUG: unable to handle kernel NULL pointer dereference at (null)
> [    0.035994] IP: [<c102c79a>] try_to_wake_up+0x2f/0x174
> [    0.035994] *pde = 00000000 
> [    0.035994] Oops: 0000 [#1] DEBUG_PAGEALLOC
> [    0.035994] last sysfs file: 
> 
> and i bisected it down to this commit. The crash was probably 
> pre-existing - stackprotector was not enabled in this type of 
> cross-build i did.

here's another crashlog:

[    0.025010] Checking 'hlt' instruction... OK.
[    0.032017] calling  spawn_ksoftirqd+0x0/0x48 @ 1
[    0.033024] BUG: unable to handle kernel NULL pointer dereference at (null)
[    0.033994] IP: [<c102b00d>] try_to_wake_up+0x2f/0x174
[    0.033994] *pde = 00000000 
[    0.033994] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.033994] last sysfs file: 
[    0.033994] Modules linked in:
[    0.033994] 
[    0.033994] Pid: 1, comm: swapper Not tainted (2.6.31-rc6-00024-g23386d6-dirty #9074) 
[    0.033994] EIP: 0060:[<c102b00d>] EFLAGS: 00010046 CPU: 0
[    0.033994] EIP is at try_to_wake_up+0x2f/0x174
[    0.033994] EAX: 0935b29c EBX: 0000000f ECX: 00000000 EDX: 00000000
[    0.033994] ESI: 00000000 EDI: 00000000 EBP: f7051edc ESP: f7051eb8
[    0.033994]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.033994] Process swapper (pid: 1, ti=f7050000 task=f7048000 task.ti=f7050000)
[    0.033994] Stack:
[    0.033994]  00000246 c1045384 00000000 c1b8800c 00000246 0935b29c c1a3b088 00000000
[    0.033994] <0> 00000000 f7051ee8 c102b1c7 0935b29c f7051f40 c104538e c1034aed 00000000
[    0.033994] <0> c1a30e5f 00000000 00000001 dead4ead ffffffff ffffffff c1eb1e04 00000000
[    0.033994] Call Trace:
[    0.033994]  [<c1045384>] ? kthread_create+0x63/0xdb
[    0.033994]  [<c102b1c7>] ? wake_up_process+0x1b/0x2e
[    0.033994]  [<c104538e>] ? kthread_create+0x6d/0xdb
[    0.033994]  [<c1034aed>] ? ksoftirqd+0x0/0xb8
[    0.033994]  [<c1048dc8>] ? ktime_get_ts+0x4e/0x64
[    0.033994]  [<c1d7446b>] ? cpu_callback+0x3e/0x94
[    0.033994]  [<c1034aed>] ? ksoftirqd+0x0/0xb8
[    0.033994]  [<c1d41f3c>] ? spawn_ksoftirqd+0x22/0x48
[    0.033994]  [<c100113c>] ? _stext+0x54/0x135
[    0.033994]  [<c1d41f1a>] ? spawn_ksoftirqd+0x0/0x48
[    0.033994]  [<c1002e75>] ? restore_all_notrace+0x0/0x18
[    0.033994]  [<c1055ce9>] ? trace_hardirqs_on_caller+0xb9/0xf2
[    0.033994]  [<c13294ec>] ? trace_hardirqs_on_thunk+0xc/0x10
[    0.033994]  [<c1002e75>] ? restore_all_notrace+0x0/0x18
[    0.033994]  [<c1d302ab>] ? kernel_init+0x0/0xec
[    0.033994]  [<c1d302ed>] ? kernel_init+0x42/0xec
[    0.033994]  [<c1d302ab>] ? kernel_init+0x0/0xec
[    0.033994]  [<c10037a7>] ? kernel_thread_helper+0x7/0x58
[    0.033994] Code: 56 89 c7 53 89 d3 83 ec 18 89 4d e4 65 a1 14 00 00 00 89 45 f0 31 c0 8d 55 ec 89 f8 e8 88 d3 ff ff 89 45 e8 31 f6 e8 8e f5 ff ff <8b> 07 85 c3 0f 84 15 01 00 00 31 f6 83 7f 48 00 0f 85 c8 00 00 
[    0.033994] EIP: [<c102b00d>] try_to_wake_up+0x2f/0x174 SS:ESP 0068:f7051eb8

here's the disassembly of try_to_wake_up():

c102afde <try_to_wake_up>:
c102afde:	55                   	push   %ebp
c102afdf:	89 e5                	mov    %esp,%ebp
c102afe1:	57                   	push   %edi
c102afe2:	56                   	push   %esi
c102afe3:	89 c7                	mov    %eax,%edi
c102afe5:	53                   	push   %ebx
c102afe6:	89 d3                	mov    %edx,%ebx
c102afe8:	83 ec 18             	sub    $0x18,%esp
c102afeb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c102afee:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
c102aff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c102aff7:	31 c0                	xor    %eax,%eax
c102aff9:	8d 55 ec             	lea    -0x14(%ebp),%edx
c102affc:	89 f8                	mov    %edi,%eax
c102affe:	e8 88 d3 ff ff       	call   c102838b <task_rq_lock>
c102b003:	89 45 e8             	mov    %eax,-0x18(%ebp)
c102b006:	31 f6                	xor    %esi,%esi
c102b008:	e8 8e f5 ff ff       	call   c102a59b <update_rq_clock>
c102b00d:	8b 07                	mov    (%edi),%eax
c102b00f:	85 c3                	test   %eax,%ebx
c102b011:	0f 84 15 01 00 00    	je     c102b12c <try_to_wake_up+0x14e>
c102b017:	31 f6                	xor    %esi,%esi
c102b019:	83 7f 48 00          	cmpl   $0x0,0x48(%edi)
c102b01d:	0f 85 c8 00 00 00    	jne    c102b0eb <try_to_wake_up+0x10d>
c102b023:	83 87 1c 01 00 00 01 	addl   $0x1,0x11c(%edi)
c102b02a:	83 97 20 01 00 00 00 	adcl   $0x0,0x120(%edi)
c102b031:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c102b035:	74 0e                	je     c102b045 <try_to_wake_up+0x67>
c102b037:	83 87 24 01 00 00 01 	addl   $0x1,0x124(%edi)
c102b03e:	83 97 28 01 00 00 00 	adcl   $0x0,0x128(%edi)
c102b045:	83 87 34 01 00 00 01 	addl   $0x1,0x134(%edi)
c102b04c:	83 97 38 01 00 00 00 	adcl   $0x0,0x138(%edi)
c102b053:	8b 45 e8             	mov    -0x18(%ebp),%eax
c102b056:	89 fa                	mov    %edi,%edx
c102b058:	b9 01 00 00 00       	mov    $0x1,%ecx
c102b05d:	be 01 00 00 00       	mov    $0x1,%esi
c102b062:	e8 04 8e ff ff       	call   c1023e6b <activate_task>
c102b067:	89 e0                	mov    %esp,%eax
c102b069:	25 00 e0 ff ff       	and    $0xffffe000,%eax
c102b06e:	f7 40 14 00 ff ff 07 	testl  $0x7ffff00,0x14(%eax)
c102b075:	75 74                	jne    c102b0eb <try_to_wake_up+0x10d>
c102b077:	8b 35 40 2b b8 c1    	mov    0xc1b82b40,%esi
c102b07d:	8b 56 54             	mov    0x54(%esi),%edx
c102b080:	8b 4e 58             	mov    0x58(%esi),%ecx
c102b083:	89 55 dc             	mov    %edx,-0x24(%ebp)
c102b086:	89 4d e0             	mov    %ecx,-0x20(%ebp)
c102b089:	8b 56 70             	mov    0x70(%esi),%edx
c102b08c:	8b 46 6c             	mov    0x6c(%esi),%eax
c102b08f:	89 d1                	mov    %edx,%ecx
c102b091:	09 c1                	or     %eax,%ecx
c102b093:	74 0c                	je     c102b0a1 <try_to_wake_up+0xc3>
c102b095:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c102b098:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c102b09b:	29 c1                	sub    %eax,%ecx
c102b09d:	19 d3                	sbb    %edx,%ebx
c102b09f:	eb 12                	jmp    c102b0b3 <try_to_wake_up+0xd5>
c102b0a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c102b0a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c102b0a7:	2b 8e 84 00 00 00    	sub    0x84(%esi),%ecx
c102b0ad:	1b 9e 88 00 00 00    	sbb    0x88(%esi),%ebx
c102b0b3:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
c102b0b9:	8b 96 90 00 00 00    	mov    0x90(%esi),%edx
c102b0bf:	29 c1                	sub    %eax,%ecx
c102b0c1:	19 d3                	sbb    %edx,%ebx
c102b0c3:	0f ac d9 03          	shrd   $0x3,%ebx,%ecx
c102b0c7:	c1 fb 03             	sar    $0x3,%ebx
c102b0ca:	01 c1                	add    %eax,%ecx
c102b0cc:	11 d3                	adc    %edx,%ebx
c102b0ce:	8b 46 54             	mov    0x54(%esi),%eax
c102b0d1:	8b 56 58             	mov    0x58(%esi),%edx
c102b0d4:	89 8e 8c 00 00 00    	mov    %ecx,0x8c(%esi)
c102b0da:	89 9e 90 00 00 00    	mov    %ebx,0x90(%esi)
c102b0e0:	89 46 6c             	mov    %eax,0x6c(%esi)
c102b0e3:	89 56 70             	mov    %edx,0x70(%esi)
c102b0e6:	be 01 00 00 00       	mov    $0x1,%esi
c102b0eb:	83 3d 24 79 d2 c1 00 	cmpl   $0x0,0xc1d27924
c102b0f2:	74 1b                	je     c102b10f <try_to_wake_up+0x131>
c102b0f4:	8b 1d 28 79 d2 c1    	mov    0xc1d27928,%ebx
c102b0fa:	85 db                	test   %ebx,%ebx
c102b0fc:	74 11                	je     c102b10f <try_to_wake_up+0x131>
c102b0fe:	89 f1                	mov    %esi,%ecx
c102b100:	89 fa                	mov    %edi,%edx
c102b102:	8b 45 e8             	mov    -0x18(%ebp),%eax
c102b105:	ff 13                	call   *(%ebx)
c102b107:	83 c3 04             	add    $0x4,%ebx
c102b10a:	83 3b 00             	cmpl   $0x0,(%ebx)
c102b10d:	eb ed                	jmp    c102b0fc <try_to_wake_up+0x11e>
c102b10f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c102b112:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c102b115:	8b 82 34 04 00 00    	mov    0x434(%edx),%eax
c102b11b:	89 fa                	mov    %edi,%edx
c102b11d:	8b 58 28             	mov    0x28(%eax),%ebx
c102b120:	8b 45 e8             	mov    -0x18(%ebp),%eax
c102b123:	ff 53 10             	call   *0x10(%ebx)
c102b126:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
c102b12c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c102b12f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c102b132:	e8 61 e7 7c 00       	call   c17f9898 <_spin_unlock_irqrestore>
c102b137:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c102b13a:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
c102b141:	89 f0                	mov    %esi,%eax
c102b143:	74 05                	je     c102b14a <try_to_wake_up+0x16c>
c102b145:	e8 59 3f 00 00       	call   c102f0a3 <__stack_chk_fail>
c102b14a:	83 c4 18             	add    $0x18,%esp
c102b14d:	5b                   	pop    %ebx
c102b14e:	5e                   	pop    %esi
c102b14f:	5f                   	pop    %edi
c102b150:	c9                   	leave  
c102b151:	c3                   	ret    

we crash straight after the call to update_rq_clock:

c102b008:	e8 8e f5 ff ff       	call   c102a59b <update_rq_clock>
c102b00d:	8b 07                	mov    (%edi),%eax

EDI got zero:

[    0.035994] EAX: e7775505 EBX: 0000000f ECX: 00000000 EDX: 00000000
[    0.035994] ESI: 00000000 EDI: 00000000 EBP: f7051f20 ESP: f7051efc

update_rq_clock() looks like this:

c102a59b <update_rq_clock>:
c102a59b:	55                   	push   %ebp
c102a59c:	89 e5                	mov    %esp,%ebp
c102a59e:	53                   	push   %ebx
c102a59f:	89 c3                	mov    %eax,%ebx
c102a5a1:	83 ec 04             	sub    $0x4,%esp
c102a5a4:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
c102a5aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
c102a5ad:	31 c0                	xor    %eax,%eax
c102a5af:	e8 25 03 02 00       	call   c104a8d9 <sched_clock_cpu>
c102a5b4:	89 83 44 04 00 00    	mov    %eax,0x444(%ebx)
c102a5ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
c102a5bd:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
c102a5c4:	89 93 48 04 00 00    	mov    %edx,0x448(%ebx)
c102a5ca:	74 05                	je     c102a5d1 <update_rq_clock+0x36>
c102a5cc:	e8 d2 4a 00 00       	call   c102f0a3 <__stack_chk_fail>
c102a5d1:	58                   	pop    %eax
c102a5d2:	5b                   	pop    %ebx
c102a5d3:	c9                   	leave  
c102a5d4:	c3                   	ret    

and sched_clock_cpu() looks like this:

c104a8d9 <sched_clock_cpu>:
c104a8d9:	55                   	push   %ebp
c104a8da:	89 e5                	mov    %esp,%ebp
c104a8dc:	57                   	push   %edi
c104a8dd:	56                   	push   %esi
c104a8de:	89 c6                	mov    %eax,%esi
c104a8e0:	53                   	push   %ebx
c104a8e1:	83 ec 24             	sub    $0x24,%esp
c104a8e4:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
c104a8ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c104a8ed:	31 c0                	xor    %eax,%eax
c104a8ef:	83 3d f8 da d2 c1 00 	cmpl   $0x0,0xc1d2daf8
c104a8f6:	74 0e                	je     c104a906 <sched_clock_cpu+0x2d>
c104a8f8:	e8 5a c4 fb ff       	call   c1006d57 <sched_clock>
c104a8fd:	89 c1                	mov    %eax,%ecx
c104a8ff:	89 d3                	mov    %edx,%ebx
c104a901:	e9 19 02 00 00       	jmp    c104ab1f <sched_clock_cpu+0x246>
c104a906:	89 e0                	mov    %esp,%eax
c104a908:	25 00 e0 ff ff       	and    $0xffffe000,%eax
c104a90d:	f6 40 17 04          	testb  $0x4,0x17(%eax)
c104a911:	74 11                	je     c104a924 <sched_clock_cpu+0x4b>
c104a913:	8b 0d c0 a9 b8 c1    	mov    0xc1b8a9c0,%ecx
c104a919:	8b 1d c4 a9 b8 c1    	mov    0xc1b8a9c4,%ebx
c104a91f:	e9 fb 01 00 00       	jmp    c104ab1f <sched_clock_cpu+0x246>
c104a924:	31 c9                	xor    %ecx,%ecx
c104a926:	31 db                	xor    %ebx,%ebx
c104a928:	83 3d f4 da d2 c1 00 	cmpl   $0x0,0xc1d2daf4
c104a92f:	0f 84 ea 01 00 00    	je     c104ab1f <sched_clock_cpu+0x246>
c104a935:	ff 15 10 73 b8 c1    	call   *0xc1b87310
c104a93b:	f6 c4 02             	test   $0x2,%ah
c104a93e:	74 13                	je     c104a953 <sched_clock_cpu+0x7a>
c104a940:	83 3d c0 1e eb c1 00 	cmpl   $0x0,0xc1eb1ec0
c104a947:	75 0a                	jne    c104a953 <sched_clock_cpu+0x7a>
c104a949:	c7 05 c0 1e eb c1 01 	movl   $0x1,0xc1eb1ec0
c104a950:	00 00 00 
c104a953:	e8 ff c3 fb ff       	call   c1006d57 <sched_clock>
c104a958:	85 f6                	test   %esi,%esi
c104a95a:	0f 84 e7 00 00 00    	je     c104aa47 <sched_clock_cpu+0x16e>
c104a960:	2b 05 b0 a9 b8 c1    	sub    0xc1b8a9b0,%eax
c104a966:	c7 05 ac a9 b8 c1 00 	movl   $0x0,0xc1b8a9ac
c104a96d:	00 00 00 
c104a970:	1b 15 b4 a9 b8 c1    	sbb    0xc1b8a9b4,%edx
c104a976:	c7 05 ac a9 b8 c1 00 	movl   $0x0,0xc1b8a9ac
c104a97d:	00 00 00 
c104a980:	8b 35 b8 a9 b8 c1    	mov    0xc1b8a9b8,%esi
c104a986:	8b 3d bc a9 b8 c1    	mov    0xc1b8a9bc,%edi
c104a98c:	85 d2                	test   %edx,%edx
c104a98e:	79 04                	jns    c104a994 <sched_clock_cpu+0xbb>
c104a990:	31 c0                	xor    %eax,%eax
c104a992:	31 d2                	xor    %edx,%edx
c104a994:	89 c1                	mov    %eax,%ecx
c104a996:	a1 c0 a9 b8 c1       	mov    0xc1b8a9c0,%eax
c104a99b:	89 d3                	mov    %edx,%ebx
c104a99d:	8b 15 c4 a9 b8 c1    	mov    0xc1b8a9c4,%edx
c104a9a3:	01 f1                	add    %esi,%ecx
c104a9a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c104a9a8:	89 f0                	mov    %esi,%eax
c104a9aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c104a9ad:	11 fb                	adc    %edi,%ebx
c104a9af:	89 fa                	mov    %edi,%edx
c104a9b1:	2b 45 d0             	sub    -0x30(%ebp),%eax
c104a9b4:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c104a9b7:	83 fa 00             	cmp    $0x0,%edx
c104a9ba:	7f 15                	jg     c104a9d1 <sched_clock_cpu+0xf8>
c104a9bc:	7c 05                	jl     c104a9c3 <sched_clock_cpu+0xea>
c104a9be:	83 f8 00             	cmp    $0x0,%eax
c104a9c1:	77 0e                	ja     c104a9d1 <sched_clock_cpu+0xf8>
c104a9c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c104a9c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c104a9c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c104a9cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
c104a9cf:	eb 06                	jmp    c104a9d7 <sched_clock_cpu+0xfe>
c104a9d1:	89 75 d8             	mov    %esi,-0x28(%ebp)
c104a9d4:	89 7d dc             	mov    %edi,-0x24(%ebp)
c104a9d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c104a9da:	81 c6 a8 41 0f 00    	add    $0xf41a8,%esi
c104a9e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c104a9e3:	83 d7 00             	adc    $0x0,%edi
c104a9e6:	29 f0                	sub    %esi,%eax
c104a9e8:	19 fa                	sbb    %edi,%edx
c104a9ea:	83 fa 00             	cmp    $0x0,%edx
c104a9ed:	7f 0d                	jg     c104a9fc <sched_clock_cpu+0x123>
c104a9ef:	7c 05                	jl     c104a9f6 <sched_clock_cpu+0x11d>
c104a9f1:	83 f8 00             	cmp    $0x0,%eax
c104a9f4:	77 06                	ja     c104a9fc <sched_clock_cpu+0x123>
c104a9f6:	89 75 d0             	mov    %esi,-0x30(%ebp)
c104a9f9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c104a9fc:	89 c8                	mov    %ecx,%eax
c104a9fe:	89 da                	mov    %ebx,%edx
c104aa00:	2b 45 d8             	sub    -0x28(%ebp),%eax
c104aa03:	1b 55 dc             	sbb    -0x24(%ebp),%edx
c104aa06:	83 fa 00             	cmp    $0x0,%edx
c104aa09:	7f 0d                	jg     c104aa18 <sched_clock_cpu+0x13f>
c104aa0b:	7c 05                	jl     c104aa12 <sched_clock_cpu+0x139>
c104aa0d:	83 f8 00             	cmp    $0x0,%eax
c104aa10:	77 06                	ja     c104aa18 <sched_clock_cpu+0x13f>
c104aa12:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c104aa15:	8b 5d dc             	mov    -0x24(%ebp),%ebx
c104aa18:	89 c8                	mov    %ecx,%eax
c104aa1a:	89 da                	mov    %ebx,%edx
c104aa1c:	2b 45 d0             	sub    -0x30(%ebp),%eax
c104aa1f:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c104aa22:	85 d2                	test   %edx,%edx
c104aa24:	78 06                	js     c104aa2c <sched_clock_cpu+0x153>
c104aa26:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c104aa29:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c104aa2c:	89 0d c0 a9 b8 c1    	mov    %ecx,0xc1b8a9c0
c104aa32:	89 1d c4 a9 b8 c1    	mov    %ebx,0xc1b8a9c4
c104aa38:	c7 05 ac a9 b8 c1 01 	movl   $0x1,0xc1b8a9ac
c104aa3f:	00 00 00 
c104aa42:	e9 ce 00 00 00       	jmp    c104ab15 <sched_clock_cpu+0x23c>
c104aa47:	2b 05 b0 a9 b8 c1    	sub    0xc1b8a9b0,%eax
c104aa4d:	c7 05 ac a9 b8 c1 00 	movl   $0x0,0xc1b8a9ac
c104aa54:	00 00 00 
c104aa57:	1b 15 b4 a9 b8 c1    	sbb    0xc1b8a9b4,%edx
c104aa5d:	8b 35 b8 a9 b8 c1    	mov    0xc1b8a9b8,%esi
c104aa63:	8b 3d bc a9 b8 c1    	mov    0xc1b8a9bc,%edi
c104aa69:	85 d2                	test   %edx,%edx
c104aa6b:	79 04                	jns    c104aa71 <sched_clock_cpu+0x198>
c104aa6d:	31 c0                	xor    %eax,%eax
c104aa6f:	31 d2                	xor    %edx,%edx
c104aa71:	89 c1                	mov    %eax,%ecx
c104aa73:	a1 c0 a9 b8 c1       	mov    0xc1b8a9c0,%eax
c104aa78:	89 d3                	mov    %edx,%ebx
c104aa7a:	8b 15 c4 a9 b8 c1    	mov    0xc1b8a9c4,%edx
c104aa80:	01 f1                	add    %esi,%ecx
c104aa82:	89 45 e0             	mov    %eax,-0x20(%ebp)
c104aa85:	89 f0                	mov    %esi,%eax
c104aa87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c104aa8a:	11 fb                	adc    %edi,%ebx
c104aa8c:	89 fa                	mov    %edi,%edx
c104aa8e:	2b 45 e0             	sub    -0x20(%ebp),%eax
c104aa91:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
c104aa94:	83 fa 00             	cmp    $0x0,%edx
c104aa97:	7f 15                	jg     c104aaae <sched_clock_cpu+0x1d5>
c104aa99:	7c 05                	jl     c104aaa0 <sched_clock_cpu+0x1c7>
c104aa9b:	83 f8 00             	cmp    $0x0,%eax
c104aa9e:	77 0e                	ja     c104aaae <sched_clock_cpu+0x1d5>
c104aaa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c104aaa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c104aaa6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c104aaa9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c104aaac:	eb 06                	jmp    c104aab4 <sched_clock_cpu+0x1db>
c104aaae:	89 75 e8             	mov    %esi,-0x18(%ebp)
c104aab1:	89 7d ec             	mov    %edi,-0x14(%ebp)
c104aab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c104aab7:	81 c6 a8 41 0f 00    	add    $0xf41a8,%esi
c104aabd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c104aac0:	83 d7 00             	adc    $0x0,%edi
c104aac3:	29 f0                	sub    %esi,%eax
c104aac5:	19 fa                	sbb    %edi,%edx
c104aac7:	83 fa 00             	cmp    $0x0,%edx
c104aaca:	7f 0d                	jg     c104aad9 <sched_clock_cpu+0x200>
c104aacc:	7c 05                	jl     c104aad3 <sched_clock_cpu+0x1fa>
c104aace:	83 f8 00             	cmp    $0x0,%eax
c104aad1:	77 06                	ja     c104aad9 <sched_clock_cpu+0x200>
c104aad3:	89 75 e0             	mov    %esi,-0x20(%ebp)
c104aad6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
c104aad9:	89 c8                	mov    %ecx,%eax
c104aadb:	89 da                	mov    %ebx,%edx
c104aadd:	2b 45 e8             	sub    -0x18(%ebp),%eax
c104aae0:	1b 55 ec             	sbb    -0x14(%ebp),%edx
c104aae3:	83 fa 00             	cmp    $0x0,%edx
c104aae6:	7f 0d                	jg     c104aaf5 <sched_clock_cpu+0x21c>
c104aae8:	7c 05                	jl     c104aaef <sched_clock_cpu+0x216>
c104aaea:	83 f8 00             	cmp    $0x0,%eax
c104aaed:	77 06                	ja     c104aaf5 <sched_clock_cpu+0x21c>
c104aaef:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c104aaf2:	8b 5d ec             	mov    -0x14(%ebp),%ebx
c104aaf5:	89 c8                	mov    %ecx,%eax
c104aaf7:	89 da                	mov    %ebx,%edx
c104aaf9:	2b 45 e0             	sub    -0x20(%ebp),%eax
c104aafc:	1b 55 e4             	sbb    -0x1c(%ebp),%edx
c104aaff:	85 d2                	test   %edx,%edx
c104ab01:	78 06                	js     c104ab09 <sched_clock_cpu+0x230>
c104ab03:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c104ab06:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
c104ab09:	89 0d c0 a9 b8 c1    	mov    %ecx,0xc1b8a9c0
c104ab0f:	89 1d c4 a9 b8 c1    	mov    %ebx,0xc1b8a9c4
c104ab15:	c7 05 ac a9 b8 c1 01 	movl   $0x1,0xc1b8a9ac
c104ab1c:	00 00 00 
c104ab1f:	89 c8                	mov    %ecx,%eax
c104ab21:	89 da                	mov    %ebx,%edx
c104ab23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c104ab26:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
c104ab2d:	74 05                	je     c104ab34 <sched_clock_cpu+0x25b>
c104ab2f:	e8 6f 45 fe ff       	call   c102f0a3 <__stack_chk_fail>
c104ab34:	83 c4 24             	add    $0x24,%esp
c104ab37:	5b                   	pop    %ebx
c104ab38:	5e                   	pop    %esi
c104ab39:	5f                   	pop    %edi
c104ab3a:	c9                   	leave  
c104ab3b:	c3                   	ret    

and ... to make things murkier, we also have:

 CONFIG_PARAVIRT_GUEST=y
 CONFIG_PARAVIRT=y
 CONFIG_PARAVIRT_CLOCK=y
 CONFIG_PARAVIRT_DEBUG=y

SMP is disabled though.

Based on the disassembly i see no pathway for EDI to become 
corrupted, so the theory of stack-protector somehow corrupting it 
can be excluded in the first round of analysis.

Looking further up in the call chain and the assembly, in this UP 
build, try_to_wake() up could be called with NULL (%eax == 0) and 
survive up to this point of crash. The caller was wake_up_process() 
c102b1c7, which just passed through %eax from the call-site which is 
kthread_create():

c1045384:       a1 00 1e eb c1          mov    0xc1eb1e00,%eax
c1045389:       e8 1e 5e fe ff          call   c102b1ac <wake_up_process>
c104538e:       8d 45 bc                lea    -0x44(%ebp),%eax

so the question is, what value is within 0xc1eb1e00 at the point of 
crash? It's the following variable:

   c1eb1e00 B kthreadd_task

I've hacked the die handler to print out kthreadd_task, and it 
gives:

[    0.033994] kthreadd_task: (null)

so we've got a NULL there.

In fact i dont see any proper serialization here: there appears to 
be a race between the initial task and the init task (which are not 
one and the same). The race is possibly timing dependent as well, 
hence the (in hindsight, false) dependency on the stackprotector 
commit.

The fix below solves the problem. I think the bug was introduced 
via:

  cdd140b: kthreads: simplify the startup synchronization

and i've put a -stable backport tag on it as well, as it could 
trigger anywhere.

	Ingo

--------------------->
>From 43446f77df71e2a316087252485ad7db604fd4b6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 1 Sep 2009 13:36:34 +0200
Subject: [PATCH] kthreads: Fix startup synchronization boot crash

-tip testing found this bootup crash:

[    0.025010] Checking 'hlt' instruction... OK.
[    0.032017] calling  spawn_ksoftirqd+0x0/0x48 @ 1
[    0.033024] BUG: unable to handle kernel NULL pointer dereference at (null)
[    0.033994] IP: [<c102b00d>] try_to_wake_up+0x2f/0x174
[    0.033994] *pde = 00000000
[    0.033994] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.033994] last sysfs file:
[    0.033994] Modules linked in:
[    0.033994]
[    0.033994] Pid: 1, comm: swapper Not tainted (2.6.31-rc6-00024-g23386d6-dirty #9074)
[    0.033994] EIP: 0060:[<c102b00d>] EFLAGS: 00010046 CPU: 0
[    0.033994] EIP is at try_to_wake_up+0x2f/0x174
[    0.033994] EAX: 0935b29c EBX: 0000000f ECX: 00000000 EDX: 00000000
[    0.033994] ESI: 00000000 EDI: 00000000 EBP: f7051edc ESP: f7051eb8
[    0.033994]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.033994] Process swapper (pid: 1, ti=f7050000 task=f7048000 task.ti=f7050000)
[    0.033994] Stack:
[    0.033994]  00000246 c1045384 00000000 c1b8800c 00000246 0935b29c c1a3b088 00000000
[    0.033994] <0> 00000000 f7051ee8 c102b1c7 0935b29c f7051f40 c104538e c1034aed 00000000
[    0.033994] <0> c1a30e5f 00000000 00000001 dead4ead ffffffff ffffffff c1eb1e04 00000000
[    0.033994] Call Trace:
[    0.033994]  [<c1045384>] ? kthread_create+0x63/0xdb
[    0.033994]  [<c102b1c7>] ? wake_up_process+0x1b/0x2e
[    0.033994]  [<c104538e>] ? kthread_create+0x6d/0xdb
[    0.033994]  [<c1034aed>] ? ksoftirqd+0x0/0xb8
[    0.033994]  [<c1048dc8>] ? ktime_get_ts+0x4e/0x64
[    0.033994]  [<c1d7446b>] ? cpu_callback+0x3e/0x94
[    0.033994]  [<c1034aed>] ? ksoftirqd+0x0/0xb8
[    0.033994]  [<c1d41f3c>] ? spawn_ksoftirqd+0x22/0x48
[    0.033994]  [<c100113c>] ? _stext+0x54/0x135
[    0.033994]  [<c1d41f1a>] ? spawn_ksoftirqd+0x0/0x48
[    0.033994]  [<c1002e75>] ? restore_all_notrace+0x0/0x18
[    0.033994]  [<c1055ce9>] ? trace_hardirqs_on_caller+0xb9/0xf2
[    0.033994]  [<c13294ec>] ? trace_hardirqs_on_thunk+0xc/0x10
[    0.033994]  [<c1002e75>] ? restore_all_notrace+0x0/0x18
[    0.033994]  [<c1d302ab>] ? kernel_init+0x0/0xec
[    0.033994]  [<c1d302ed>] ? kernel_init+0x42/0xec
[    0.033994]  [<c1d302ab>] ? kernel_init+0x0/0xec
[    0.033994]  [<c10037a7>] ? kernel_thread_helper+0x7/0x58

Which is caused by kthreadd_task being NULL.

The modification of that variable is protected by the BKL, but
the _ordering_ of the initial task (which becomes the idle
thread of CPU0) and the init task (which is spawned by the
initial task) is not synchronized.

So we can occasionally end up init running sooner than
rest_init(), and the ksoftirqd creation failing in
kthread_create() due to the NULL kthreadd_task value.

Add a completion to serialize this - made dependent on the
kthreadd_task pointer value. (which will serialize fine right
now as both are accessed via the BKL.)

(I think this code could be cleaned up further to have less
open-coded serialization, the fix here is the minimal change to
fix the regression.)

I think a side-effect of this recent commit might have opened
that race:

  cdd140b: kthreads: simplify the startup synchronization

But it needs certain timing sequences to trigger.

c: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kthread.h |    1 +
 init/main.c             |    2 ++
 kernel/kthread.c        |    5 +++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index aabc8a1..1ca19fa 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -33,5 +33,6 @@ int kthread_should_stop(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
+extern struct completion kthreadd_task_init_done;
 
 #endif /* _LINUX_KTHREAD_H */
diff --git a/init/main.c b/init/main.c
index 11f4f14..6c1b10b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -455,6 +455,8 @@ static noinline void __init_refok rest_init(void)
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	complete(&kthreadd_task_init_done);
+
 	unlock_kernel();
 
 	/*
diff --git a/kernel/kthread.c b/kernel/kthread.c
index eb8751a..6ec4643 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -20,7 +20,9 @@
 
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
+
 struct task_struct *kthreadd_task;
+DECLARE_COMPLETION(kthreadd_task_init_done);
 
 struct kthread_create_info
 {
@@ -129,6 +131,9 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 	list_add_tail(&create.list, &kthread_create_list);
 	spin_unlock(&kthread_create_lock);
 
+	if (unlikely(!kthreadd_task))
+		wait_for_completion(&kthreadd_task_init_done);
+
 	wake_up_process(kthreadd_task);
 	wait_for_completion(&create.done);
 
