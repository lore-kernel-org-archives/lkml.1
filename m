Return-Path: <linux-kernel-owner+w=401wt.eu-S935576AbXJQRMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576AbXJQRMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763047AbXJQRMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:12:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49486 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762874AbXJQRMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:12:01 -0400
Date: Wed, 17 Oct 2007 19:11:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017171149.GA26139@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017165949.GF15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > and the oopsing instruction is that load of "sg->page" in the assembly 
> > code:
> > 
> > 	mov    0x10(%esi),%eax		# %eax = sg->page
> > 	lea    0x10(%esi),%edx		# %edx = sg+1;
> > 	test   $0x1,%al			# if (unlikely(sg_is_chain()))
> > 	jne    +76
> > 
> > Jens?
> 
> Yep, that's what I came up with as well - I asked Ingo for a dump in 
> private, but ended up just using ksymoops to decode the line.
> 
> The way blk_rq_map_sg() operates is that it ends up doing a
> 
>         next_sg = sg_next(sg);
> 
> even though sg may be the last entry. Perhaps this is crapping out, 
> although if sg is a valid address, then sg + 1 should be as well. 
> next_sg may end up being crap, in fact it will, but we'll never use 
> that unless there are more entries to fill. And if there is, then both 
> sg and next_sg were valid.

find below the disassembled code. Here's the faulting source line 
according to gdb:

(gdb) list *0x78406669
0x78406669 is in blk_rq_map_sg (include/linux/scatterlist.h:48).
43       */
44      static inline struct scatterlist *sg_next(struct scatterlist *sg)
45      {
46              sg++;
47
48              if (unlikely(sg_is_chain(sg)))
49                      sg = sg_chain_ptr(sg);
50
51              return sg;
52      }

(gdb) list *0x78406673
0x78406673 is in blk_rq_map_sg (block/ll_rw_blk.c:1355).
1350                    } else {
1351    new_segment:
1352                            sg = next_sg;
1353                            next_sg = sg_next(sg);
1354
1355                            sg->page = bvec->bv_page;
1356                            sg->length = nbytes;
1357                            sg->offset = bvec->bv_offset;
1358                            nsegs++;
1359                    }
(gdb)

the compiler is gcc-4.2.2. (vanilla, built from sources)

	Ingo

784065b0 <blk_rq_map_sg>:
784065b0:	55                   	push   %ebp
784065b1:	57                   	push   %edi
784065b2:	56                   	push   %esi
784065b3:	53                   	push   %ebx
784065b4:	83 ec 28             	sub    $0x28,%esp
784065b7:	89 44 24 04          	mov    %eax,0x4(%esp)
784065bb:	8b 98 08 01 00 00    	mov    0x108(%eax),%ebx
784065c1:	83 e3 01             	and    $0x1,%ebx
784065c4:	89 5c 24 18          	mov    %ebx,0x18(%esp)
784065c8:	8b 52 3c             	mov    0x3c(%edx),%edx
784065cb:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
784065d2:	00 
784065d3:	85 d2                	test   %edx,%edx
784065d5:	89 54 24 20          	mov    %edx,0x20(%esp)
784065d9:	0f 84 fc 00 00 00    	je     784066db <blk_rq_map_sg+0x12b>
784065df:	89 ce                	mov    %ecx,%esi
784065e1:	31 d2                	xor    %edx,%edx
784065e3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
784065e7:	8b 44 24 20          	mov    0x20(%esp),%eax
784065eb:	0f b7 58 1a          	movzwl 0x1a(%eax),%ebx
784065ef:	8b 48 30             	mov    0x30(%eax),%ecx
784065f2:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
784065f6:	0f b7 40 18          	movzwl 0x18(%eax),%eax
784065fa:	39 d8                	cmp    %ebx,%eax
784065fc:	0f 8e c6 00 00 00    	jle    784066c8 <blk_rq_map_sg+0x118>
78406602:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
78406605:	8d 1c 81             	lea    (%ecx,%eax,4),%ebx
78406608:	0f b6 44 24 18       	movzbl 0x18(%esp),%eax
7840660d:	88 44 24 27          	mov    %al,0x27(%esp)
78406611:	e9 8b 00 00 00       	jmp    784066a1 <blk_rq_map_sg+0xf1>
78406616:	8b 4c 24 10          	mov    0x10(%esp),%ecx
7840661a:	8b 41 0c             	mov    0xc(%ecx),%eax
7840661d:	8b 4c 24 04          	mov    0x4(%esp),%ecx
78406621:	01 e8                	add    %ebp,%eax
78406623:	89 44 24 08          	mov    %eax,0x8(%esp)
78406627:	3b 81 6c 01 00 00    	cmp    0x16c(%ecx),%eax
7840662d:	0f 87 80 00 00 00    	ja     784066b3 <blk_rq_map_sg+0x103>
78406633:	a1 18 ec d7 78       	mov    0x78d7ec18,%eax
78406638:	8b 0a                	mov    (%edx),%ecx
7840663a:	29 c1                	sub    %eax,%ecx
7840663c:	c1 f9 05             	sar    $0x5,%ecx
7840663f:	c1 e1 0c             	shl    $0xc,%ecx
78406642:	03 4a 08             	add    0x8(%edx),%ecx
78406645:	8b 52 04             	mov    0x4(%edx),%edx
78406648:	01 ca                	add    %ecx,%edx
7840664a:	89 54 24 0c          	mov    %edx,0xc(%esp)
7840664e:	8b 3b                	mov    (%ebx),%edi
78406650:	89 fa                	mov    %edi,%edx
78406652:	29 c2                	sub    %eax,%edx
78406654:	89 d0                	mov    %edx,%eax
78406656:	c1 f8 05             	sar    $0x5,%eax
78406659:	c1 e0 0c             	shl    $0xc,%eax
7840665c:	03 43 08             	add    0x8(%ebx),%eax
7840665f:	39 44 24 0c          	cmp    %eax,0xc(%esp)
78406663:	0f 84 7e 00 00 00    	je     784066e7 <blk_rq_map_sg+0x137>
78406669:	8b 46 10             	mov    0x10(%esi),%eax
7840666c:	8d 56 10             	lea    0x10(%esi),%edx
7840666f:	a8 01                	test   $0x1,%al
78406671:	75 4c                	jne    784066bf <blk_rq_map_sg+0x10f>
78406673:	89 3e                	mov    %edi,(%esi)
78406675:	89 6e 0c             	mov    %ebp,0xc(%esi)
78406678:	8b 43 08             	mov    0x8(%ebx),%eax
7840667b:	89 46 04             	mov    %eax,0x4(%esi)
7840667e:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
78406683:	89 74 24 10          	mov    %esi,0x10(%esp)
78406687:	89 d6                	mov    %edx,%esi
78406689:	8b 54 24 20          	mov    0x20(%esp),%edx
7840668d:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
78406692:	0f b7 42 18          	movzwl 0x18(%edx),%eax
78406696:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
7840669a:	7e 2a                	jle    784066c6 <blk_rq_map_sg+0x116>
7840669c:	89 da                	mov    %ebx,%edx
7840669e:	83 c3 0c             	add    $0xc,%ebx
784066a1:	85 d2                	test   %edx,%edx
784066a3:	8b 6b 04             	mov    0x4(%ebx),%ebp
784066a6:	74 0b                	je     784066b3 <blk_rq_map_sg+0x103>
784066a8:	80 7c 24 27 00       	cmpb   $0x0,0x27(%esp)
784066ad:	0f 85 63 ff ff ff    	jne    78406616 <blk_rq_map_sg+0x66>
784066b3:	8b 46 10             	mov    0x10(%esi),%eax
784066b6:	8d 56 10             	lea    0x10(%esi),%edx
784066b9:	8b 3b                	mov    (%ebx),%edi
784066bb:	a8 01                	test   $0x1,%al
784066bd:	74 b4                	je     78406673 <blk_rq_map_sg+0xc3>
784066bf:	89 c2                	mov    %eax,%edx
784066c1:	83 e2 fe             	and    $0xfffffffe,%edx
784066c4:	eb ad                	jmp    78406673 <blk_rq_map_sg+0xc3>
784066c6:	89 da                	mov    %ebx,%edx
784066c8:	8b 4c 24 20          	mov    0x20(%esp),%ecx
784066cc:	8b 49 08             	mov    0x8(%ecx),%ecx
784066cf:	85 c9                	test   %ecx,%ecx
784066d1:	89 4c 24 20          	mov    %ecx,0x20(%esp)
784066d5:	0f 85 0c ff ff ff    	jne    784065e7 <blk_rq_map_sg+0x37>
784066db:	8b 44 24 14          	mov    0x14(%esp),%eax
784066df:	83 c4 28             	add    $0x28,%esp
784066e2:	5b                   	pop    %ebx
784066e3:	5e                   	pop    %esi
784066e4:	5f                   	pop    %edi
784066e5:	5d                   	pop    %ebp
784066e6:	c3                   	ret    
784066e7:	8b 44 24 04          	mov    0x4(%esp),%eax
784066eb:	8b 54 24 0c          	mov    0xc(%esp),%edx
784066ef:	8b 80 70 01 00 00    	mov    0x170(%eax),%eax
784066f5:	89 04 24             	mov    %eax,(%esp)
784066f8:	09 c1                	or     %eax,%ecx
784066fa:	8d 44 2a ff          	lea    0xffffffff(%edx,%ebp,1),%eax
784066fe:	0b 04 24             	or     (%esp),%eax
78406701:	39 c1                	cmp    %eax,%ecx
78406703:	0f 85 60 ff ff ff    	jne    78406669 <blk_rq_map_sg+0xb9>
78406709:	8b 44 24 08          	mov    0x8(%esp),%eax
7840670d:	8b 4c 24 10          	mov    0x10(%esp),%ecx
78406711:	89 41 0c             	mov    %eax,0xc(%ecx)
78406714:	e9 70 ff ff ff       	jmp    78406689 <blk_rq_map_sg+0xd9>
78406719:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

