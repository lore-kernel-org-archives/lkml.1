Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbZKSQpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbZKSQpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZKSQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:45:41 -0500
Received: from www.tglx.de ([62.245.132.106]:53472 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZKSQpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:45:40 -0500
Date: Thu, 19 Nov 2009 17:43:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Haley <aph@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <4B056FAD.2080500@redhat.com>
Message-ID: <alpine.LFD.2.00.0911191720030.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <4B0567E0.5080803@redhat.com> <alpine.LFD.2.00.0911191704110.24119@localhost.localdomain> <4B056FAD.2080500@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Andrew Haley wrote:

> Thomas Gleixner wrote:
> > On Thu, 19 Nov 2009, Andrew Haley wrote:
> >> Thomas Gleixner wrote:
> >>> There is no real obvious reason why the edi magic needs to be done
> >>> _before_ 
> >>>
> >>> 	push   %ebp
> >>> 	mov    %esp,%ebp
> >> Sure there is: unless you do the adjustment first %ebp won't be 16-aligned.
> > 
> > And why is this not done in 99% of the functions in the kernel, just
> > in this one and some random others ?
> 
> If I could see the function I might be able to tell you.  It's either a
> performance enhancement, something to do with SSE, or it's a bug.

kernel/time/timer_stats.c timer_stats_update_stats()

Here is the disassembly:

8107ad50 <timer_stats_update_stats>:
8107ad50:	57                   	push   %edi
8107ad51:	8d 7c 24 08          	lea    0x8(%esp),%edi
8107ad55:	83 e4 f0             	and    $0xfffffff0,%esp
8107ad58:	ff 77 fc             	pushl  -0x4(%edi)
8107ad5b:	55                   	push   %ebp
8107ad5c:	89 e5                	mov    %esp,%ebp
8107ad5e:	57                   	push   %edi
8107ad5f:	56                   	push   %esi
8107ad60:	53                   	push   %ebx
8107ad61:	83 ec 6c             	sub    $0x6c,%esp
8107ad64:	e8 47 92 f8 ff       	call   81003fb0 <mcount>
8107ad69:	8b 77 04             	mov    0x4(%edi),%esi
8107ad6c:	89 75 a4             	mov    %esi,-0x5c(%ebp)
8107ad6f:	65 8b 35 14 00 00 00 	mov    %gs:0x14,%esi
8107ad76:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8107ad79:	31 f6                	xor    %esi,%esi
8107ad7b:	8b 35 60 5a cd 81    	mov    0x81cd5a60,%esi
8107ad81:	8b 1f                	mov    (%edi),%ebx
8107ad83:	85 f6                	test   %esi,%esi
8107ad85:	8b 7f 08             	mov    0x8(%edi),%edi
8107ad88:	75 18                	jne    8107ada2 <timer_stats_update_stats+0x52>
8107ad8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8107ad8d:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
8107ad94:	75 53                	jne    8107ade9 <timer_stats_update_stats+0x99>
8107ad96:	83 c4 6c             	add    $0x6c,%esp
8107ad99:	5b                   	pop    %ebx
8107ad9a:	5e                   	pop    %esi
8107ad9b:	5f                   	pop    %edi
8107ad9c:	5d                   	pop    %ebp
8107ad9d:	8d 67 f8             	lea    -0x8(%edi),%esp
8107ada0:	5f                   	pop    %edi
8107ada1:	c3                   	ret    
8107ada2:	be 00 7a d6 81       	mov    $0x81d67a00,%esi
8107ada7:	89 45 ac             	mov    %eax,-0x54(%ebp)
8107adaa:	89 75 a0             	mov    %esi,-0x60(%ebp)
8107adad:	89 5d b4             	mov    %ebx,-0x4c(%ebp)
8107adb0:	64 8b 35 78 6a d6 81 	mov    %fs:0x81d66a78,%esi
8107adb7:	8b 34 b5 20 50 cd 81 	mov    -0x7e32afe0(,%esi,4),%esi
8107adbe:	89 4d b0             	mov    %ecx,-0x50(%ebp)
8107adc1:	01 75 a0             	add    %esi,-0x60(%ebp)
8107adc4:	89 55 b8             	mov    %edx,-0x48(%ebp)
8107adc7:	8b 45 a0             	mov    -0x60(%ebp),%eax
8107adca:	89 7d c0             	mov    %edi,-0x40(%ebp)
8107adcd:	e8 de f7 76 00       	call   817ea5b0 <_spin_lock_irqsave>
8107add2:	83 3d 60 5a cd 81 00 	cmpl   $0x0,0x81cd5a60
8107add9:	89 c3                	mov    %eax,%ebx
8107addb:	75 11                	jne    8107adee <timer_stats_update_stats+0x9e>
8107addd:	89 da                	mov    %ebx,%edx
8107addf:	8b 45 a0             	mov    -0x60(%ebp),%eax
8107ade2:	e8 79 fc 76 00       	call   817eaa60 <_spin_unlock_irqrestore>
8107ade7:	eb a1                	jmp    8107ad8a <timer_stats_update_stats+0x3a>
8107ade9:	e8 52 e4 fc ff       	call   81049240 <__stack_chk_fail>
8107adee:	8d 45 a8             	lea    -0x58(%ebp),%eax
8107adf1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
8107adf4:	e8 f7 fd ff ff       	call   8107abf0 <tstat_lookup>
8107adf9:	85 c0                	test   %eax,%eax
8107adfb:	74 05                	je     8107ae02 <timer_stats_update_stats+0xb2>
8107adfd:	ff 40 14             	incl   0x14(%eax)
8107ae00:	eb db                	jmp    8107addd <timer_stats_update_stats+0x8d>
8107ae02:	f0 ff 05 00 67 fd 81 	lock incl 0x81fd6700
8107ae09:	eb d2                	jmp    8107addd <timer_stats_update_stats+0x8d>
8107ae0b:	90                   	nop
8107ae0c:	90                   	nop
8107ae0d:	90                   	nop
8107ae0e:	90                   	nop
8107ae0f:	90                   	nop


There is a dozen more of those.

Thanks,

	tglx
