Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYEPPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYEPPwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYEPPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:52:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:37256 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYEPPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=bAKsL/nSGBo1uCFZuIwxRtZyeYFuPy7Co7Mk8g405SR/9Bdib3PCpJDwFBK9w1fqCFPZ/+sqkg/BYMxX4992wroJ4pHSN4MvJr4oBDtB7NBxG53+XHuMncf1xcY+o4NjU4a/QXhxS/fhYn3hv6CJz8wgZxkN2iE7lrvfi6yznPg=
Subject: Re: [PATCH] crypto: make michael_block a function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sebastian Siewior <lkml@ml.breakpoint.cc>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1210925405.4000.3.camel@johannes.berg>
References: <1210918637.5915.24.camel@brick>
	 <20080516070157.GA9769@Chamillionaire.breakpoint.cc>
	 <1210925405.4000.3.camel@johannes.berg>
Content-Type: multipart/mixed; boundary="=-1VZnPKTCgxVSgmOMPsqX"
Date: Fri, 16 May 2008 08:52:03 -0700
Message-Id: <1210953123.5915.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1VZnPKTCgxVSgmOMPsqX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2008-05-16 at 10:10 +0200, Johannes Berg wrote:
> On Fri, 2008-05-16 at 09:01 +0200, Sebastian Siewior wrote:
> > * Harvey Harrison | 2008-05-15 23:17:17 [-0700]:
> > 
> > >Make the michael_block macro a function and change the calling
> > >function to take a struct michael_mic_ctx * and the value for
> > >the initial xor with ctx->l.
> > >
> > >Also open-code xswap in its one use in michael_block.
> > Does this change have any performance impact?
> > The only user is wireless (I guess). Is it used frequently (sign every
> > packet for instance) or once in a while (in every re-keying)?
> 
> Every packet. I have no idea whether it has performance impact, very
> hard to even guess.
> 

Well, the code-size difference is significant (about 200 bytes smaller
on X86-32).  This macro is essentially an inline function that is pretty
large.

Attached find the objdump -d of the original and after the patch.  As it
is, this code isn't used anywhere that I can find as mac80211 has its
own implementation, I'm trying to see if there is much advantage in
keeping the private version over moving to the crypto one.

Harvey

--=-1VZnPKTCgxVSgmOMPsqX
Content-Disposition: attachment; filename=michael_mic.orig
Content-Type: text/plain; name=michael_mic.orig; charset=UTF-8
Content-Transfer-Encoding: 7bit


crypto/michael_mic.o:     file format elf32-i386

Disassembly of section .text:

00000000 <michael_setkey>:
   0:	83 f9 08             	cmp    $0x8,%ecx
   3:	53                   	push   %ebx
   4:	89 d3                	mov    %edx,%ebx
   6:	74 0d                	je     15 <michael_setkey+0x15>
   8:	81 08 00 00 20 00    	orl    $0x200000,(%eax)
   e:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  13:	eb 10                	jmp    25 <michael_setkey+0x25>
  15:	8b 12                	mov    (%edx),%edx
  17:	83 c0 30             	add    $0x30,%eax
  1a:	89 50 08             	mov    %edx,0x8(%eax)
  1d:	8b 53 04             	mov    0x4(%ebx),%edx
  20:	89 50 0c             	mov    %edx,0xc(%eax)
  23:	31 c0                	xor    %eax,%eax
  25:	5b                   	pop    %ebx
  26:	c3                   	ret    

00000027 <michael_init>:
  27:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
  2e:	c3                   	ret    

0000002f <michael_update>:
  2f:	55                   	push   %ebp
  30:	89 cd                	mov    %ecx,%ebp
  32:	57                   	push   %edi
  33:	56                   	push   %esi
  34:	53                   	push   %ebx
  35:	89 c3                	mov    %eax,%ebx
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	83 c3 30             	add    $0x30,%ebx
  3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  41:	89 14 24             	mov    %edx,(%esp)
  44:	8b 73 04             	mov    0x4(%ebx),%esi
  47:	85 f6                	test   %esi,%esi
  49:	0f 84 93 00 00 00    	je     e2 <michael_update+0xb3>
  4f:	b8 04 00 00 00       	mov    $0x4,%eax
  54:	29 f0                	sub    %esi,%eax
  56:	39 c8                	cmp    %ecx,%eax
  58:	89 c2                	mov    %eax,%edx
  5a:	0f 47 d1             	cmova  %ecx,%edx
  5d:	89 d1                	mov    %edx,%ecx
  5f:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  62:	8b 34 24             	mov    (%esp),%esi
  65:	c1 e9 02             	shr    $0x2,%ecx
  68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  6a:	89 d1                	mov    %edx,%ecx
  6c:	83 e1 03             	and    $0x3,%ecx
  6f:	74 02                	je     73 <michael_update+0x44>
  71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  73:	89 d0                	mov    %edx,%eax
  75:	03 43 04             	add    0x4(%ebx),%eax
  78:	83 f8 03             	cmp    $0x3,%eax
  7b:	89 43 04             	mov    %eax,0x4(%ebx)
  7e:	0f 86 d2 00 00 00    	jbe    156 <michael_update+0x127>
  84:	8b 44 24 04          	mov    0x4(%esp),%eax
  88:	29 d5                	sub    %edx,%ebp
  8a:	01 14 24             	add    %edx,(%esp)
  8d:	8b 53 08             	mov    0x8(%ebx),%edx
  90:	33 50 30             	xor    0x30(%eax),%edx
  93:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  9a:	89 53 08             	mov    %edx,0x8(%ebx)
  9d:	c1 ca 0f             	ror    $0xf,%edx
  a0:	33 53 0c             	xor    0xc(%ebx),%edx
  a3:	89 d0                	mov    %edx,%eax
  a5:	03 43 08             	add    0x8(%ebx),%eax
  a8:	89 c1                	mov    %eax,%ecx
  aa:	89 43 08             	mov    %eax,0x8(%ebx)
  ad:	81 e1 00 ff 00 ff    	and    $0xff00ff00,%ecx
  b3:	25 ff 00 ff 00       	and    $0xff00ff,%eax
  b8:	c1 e0 08             	shl    $0x8,%eax
  bb:	c1 e9 08             	shr    $0x8,%ecx
  be:	09 c1                	or     %eax,%ecx
  c0:	31 d1                	xor    %edx,%ecx
  c2:	89 ca                	mov    %ecx,%edx
  c4:	03 53 08             	add    0x8(%ebx),%edx
  c7:	89 53 08             	mov    %edx,0x8(%ebx)
  ca:	c1 ca 1d             	ror    $0x1d,%edx
  cd:	31 ca                	xor    %ecx,%edx
  cf:	89 d0                	mov    %edx,%eax
  d1:	03 43 08             	add    0x8(%ebx),%eax
  d4:	89 43 08             	mov    %eax,0x8(%ebx)
  d7:	c1 c8 02             	ror    $0x2,%eax
  da:	31 d0                	xor    %edx,%eax
  dc:	01 43 08             	add    %eax,0x8(%ebx)
  df:	89 43 0c             	mov    %eax,0xc(%ebx)
  e2:	8b 34 24             	mov    (%esp),%esi
  e5:	eb 54                	jmp    13b <michael_update+0x10c>
  e7:	8b 53 08             	mov    0x8(%ebx),%edx
  ea:	83 c6 04             	add    $0x4,%esi
  ed:	83 ed 04             	sub    $0x4,%ebp
  f0:	33 56 fc             	xor    -0x4(%esi),%edx
  f3:	89 53 08             	mov    %edx,0x8(%ebx)
  f6:	c1 ca 0f             	ror    $0xf,%edx
  f9:	33 53 0c             	xor    0xc(%ebx),%edx
  fc:	89 d0                	mov    %edx,%eax
  fe:	03 43 08             	add    0x8(%ebx),%eax
 101:	89 c1                	mov    %eax,%ecx
 103:	89 43 08             	mov    %eax,0x8(%ebx)
 106:	81 e1 00 ff 00 ff    	and    $0xff00ff00,%ecx
 10c:	25 ff 00 ff 00       	and    $0xff00ff,%eax
 111:	c1 e0 08             	shl    $0x8,%eax
 114:	c1 e9 08             	shr    $0x8,%ecx
 117:	09 c1                	or     %eax,%ecx
 119:	31 d1                	xor    %edx,%ecx
 11b:	89 ca                	mov    %ecx,%edx
 11d:	03 53 08             	add    0x8(%ebx),%edx
 120:	89 53 08             	mov    %edx,0x8(%ebx)
 123:	c1 ca 1d             	ror    $0x1d,%edx
 126:	31 ca                	xor    %ecx,%edx
 128:	89 d0                	mov    %edx,%eax
 12a:	03 43 08             	add    0x8(%ebx),%eax
 12d:	89 43 08             	mov    %eax,0x8(%ebx)
 130:	c1 c8 02             	ror    $0x2,%eax
 133:	31 d0                	xor    %edx,%eax
 135:	01 43 08             	add    %eax,0x8(%ebx)
 138:	89 43 0c             	mov    %eax,0xc(%ebx)
 13b:	83 fd 03             	cmp    $0x3,%ebp
 13e:	77 a7                	ja     e7 <michael_update+0xb8>
 140:	85 ed                	test   %ebp,%ebp
 142:	74 12                	je     156 <michael_update+0x127>
 144:	89 6b 04             	mov    %ebp,0x4(%ebx)
 147:	31 c9                	xor    %ecx,%ecx
 149:	89 df                	mov    %ebx,%edi
 14b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 14d:	89 e9                	mov    %ebp,%ecx
 14f:	83 e1 03             	and    $0x3,%ecx
 152:	74 02                	je     156 <michael_update+0x127>
 154:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
 156:	58                   	pop    %eax
 157:	5a                   	pop    %edx
 158:	5b                   	pop    %ebx
 159:	5e                   	pop    %esi
 15a:	5f                   	pop    %edi
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <michael_final>:
 15d:	57                   	push   %edi
 15e:	89 d7                	mov    %edx,%edi
 160:	56                   	push   %esi
 161:	8d 70 30             	lea    0x30(%eax),%esi
 164:	53                   	push   %ebx
 165:	8b 56 04             	mov    0x4(%esi),%edx
 168:	83 fa 01             	cmp    $0x1,%edx
 16b:	74 14                	je     181 <michael_final+0x24>
 16d:	72 0c                	jb     17b <michael_final+0x1e>
 16f:	83 fa 02             	cmp    $0x2,%edx
 172:	74 16                	je     18a <michael_final+0x2d>
 174:	83 fa 03             	cmp    $0x3,%edx
 177:	75 47                	jne    1c0 <michael_final+0x63>
 179:	eb 27                	jmp    1a2 <michael_final+0x45>
 17b:	83 76 08 5a          	xorl   $0x5a,0x8(%esi)
 17f:	eb 3f                	jmp    1c0 <michael_final+0x63>
 181:	0f b6 40 30          	movzbl 0x30(%eax),%eax
 185:	80 cc 5a             	or     $0x5a,%ah
 188:	eb 33                	jmp    1bd <michael_final+0x60>
 18a:	0f b6 50 30          	movzbl 0x30(%eax),%edx
 18e:	0f b6 46 01          	movzbl 0x1(%esi),%eax
 192:	81 ca 00 00 5a 00    	or     $0x5a0000,%edx
 198:	c1 e0 08             	shl    $0x8,%eax
 19b:	09 c2                	or     %eax,%edx
 19d:	31 56 08             	xor    %edx,0x8(%esi)
 1a0:	eb 1e                	jmp    1c0 <michael_final+0x63>
 1a2:	0f b6 40 30          	movzbl 0x30(%eax),%eax
 1a6:	0f b6 56 01          	movzbl 0x1(%esi),%edx
 1aa:	0d 00 00 00 5a       	or     $0x5a000000,%eax
 1af:	c1 e2 08             	shl    $0x8,%edx
 1b2:	09 d0                	or     %edx,%eax
 1b4:	0f b6 56 02          	movzbl 0x2(%esi),%edx
 1b8:	c1 e2 10             	shl    $0x10,%edx
 1bb:	09 d0                	or     %edx,%eax
 1bd:	31 46 08             	xor    %eax,0x8(%esi)
 1c0:	8b 4e 08             	mov    0x8(%esi),%ecx
 1c3:	c1 c9 0f             	ror    $0xf,%ecx
 1c6:	33 4e 0c             	xor    0xc(%esi),%ecx
 1c9:	89 c8                	mov    %ecx,%eax
 1cb:	03 46 08             	add    0x8(%esi),%eax
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	89 46 08             	mov    %eax,0x8(%esi)
 1d3:	81 e2 00 ff 00 ff    	and    $0xff00ff00,%edx
 1d9:	25 ff 00 ff 00       	and    $0xff00ff,%eax
 1de:	c1 e0 08             	shl    $0x8,%eax
 1e1:	c1 ea 08             	shr    $0x8,%edx
 1e4:	09 c2                	or     %eax,%edx
 1e6:	31 ca                	xor    %ecx,%edx
 1e8:	89 d0                	mov    %edx,%eax
 1ea:	03 46 08             	add    0x8(%esi),%eax
 1ed:	89 46 08             	mov    %eax,0x8(%esi)
 1f0:	c1 c8 1d             	ror    $0x1d,%eax
 1f3:	31 d0                	xor    %edx,%eax
 1f5:	89 c2                	mov    %eax,%edx
 1f7:	03 56 08             	add    0x8(%esi),%edx
 1fa:	89 56 08             	mov    %edx,0x8(%esi)
 1fd:	c1 ca 02             	ror    $0x2,%edx
 200:	31 c2                	xor    %eax,%edx
 202:	89 d3                	mov    %edx,%ebx
 204:	03 5e 08             	add    0x8(%esi),%ebx
 207:	89 5e 08             	mov    %ebx,0x8(%esi)
 20a:	c1 cb 0f             	ror    $0xf,%ebx
 20d:	31 d3                	xor    %edx,%ebx
 20f:	89 d8                	mov    %ebx,%eax
 211:	03 46 08             	add    0x8(%esi),%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	89 46 08             	mov    %eax,0x8(%esi)
 219:	81 e1 00 ff 00 ff    	and    $0xff00ff00,%ecx
 21f:	25 ff 00 ff 00       	and    $0xff00ff,%eax
 224:	c1 e0 08             	shl    $0x8,%eax
 227:	c1 e9 08             	shr    $0x8,%ecx
 22a:	09 c1                	or     %eax,%ecx
 22c:	31 d9                	xor    %ebx,%ecx
 22e:	89 ca                	mov    %ecx,%edx
 230:	03 56 08             	add    0x8(%esi),%edx
 233:	89 56 08             	mov    %edx,0x8(%esi)
 236:	c1 ca 1d             	ror    $0x1d,%edx
 239:	31 ca                	xor    %ecx,%edx
 23b:	89 d1                	mov    %edx,%ecx
 23d:	03 4e 08             	add    0x8(%esi),%ecx
 240:	89 c8                	mov    %ecx,%eax
 242:	c1 c8 02             	ror    $0x2,%eax
 245:	31 d0                	xor    %edx,%eax
 247:	89 46 0c             	mov    %eax,0xc(%esi)
 24a:	01 c8                	add    %ecx,%eax
 24c:	89 46 08             	mov    %eax,0x8(%esi)
 24f:	89 07                	mov    %eax,(%edi)
 251:	8b 46 0c             	mov    0xc(%esi),%eax
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	89 47 04             	mov    %eax,0x4(%edi)
 259:	5f                   	pop    %edi
 25a:	c3                   	ret    
Disassembly of section .init.text:

00000000 <michael_mic_init>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <michael_mic_init+0x6>
Disassembly of section .exit.text:

00000000 <michael_mic_exit>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <michael_mic_exit+0x6>

--=-1VZnPKTCgxVSgmOMPsqX
Content-Disposition: attachment; filename=michael_mic.patched
Content-Type: text/plain; name=michael_mic.patched; charset=UTF-8
Content-Transfer-Encoding: 7bit


crypto/michael_mic.o:     file format elf32-i386

Disassembly of section .text:

00000000 <michael_block>:
   0:	33 50 08             	xor    0x8(%eax),%edx
   3:	53                   	push   %ebx
   4:	89 d1                	mov    %edx,%ecx
   6:	c1 c9 0f             	ror    $0xf,%ecx
   9:	33 48 0c             	xor    0xc(%eax),%ecx
   c:	8d 14 11             	lea    (%ecx,%edx,1),%edx
   f:	89 d3                	mov    %edx,%ebx
  11:	89 50 08             	mov    %edx,0x8(%eax)
  14:	81 e3 00 ff 00 ff    	and    $0xff00ff00,%ebx
  1a:	81 e2 ff 00 ff 00    	and    $0xff00ff,%edx
  20:	c1 e2 08             	shl    $0x8,%edx
  23:	c1 eb 08             	shr    $0x8,%ebx
  26:	09 d3                	or     %edx,%ebx
  28:	31 cb                	xor    %ecx,%ebx
  2a:	89 d9                	mov    %ebx,%ecx
  2c:	03 48 08             	add    0x8(%eax),%ecx
  2f:	89 48 08             	mov    %ecx,0x8(%eax)
  32:	c1 c9 1d             	ror    $0x1d,%ecx
  35:	31 d9                	xor    %ebx,%ecx
  37:	89 ca                	mov    %ecx,%edx
  39:	03 50 08             	add    0x8(%eax),%edx
  3c:	5b                   	pop    %ebx
  3d:	89 50 08             	mov    %edx,0x8(%eax)
  40:	c1 ca 02             	ror    $0x2,%edx
  43:	31 ca                	xor    %ecx,%edx
  45:	01 50 08             	add    %edx,0x8(%eax)
  48:	89 50 0c             	mov    %edx,0xc(%eax)
  4b:	c3                   	ret    

0000004c <michael_setkey>:
  4c:	83 f9 08             	cmp    $0x8,%ecx
  4f:	53                   	push   %ebx
  50:	89 d3                	mov    %edx,%ebx
  52:	74 0d                	je     61 <michael_setkey+0x15>
  54:	81 08 00 00 20 00    	orl    $0x200000,(%eax)
  5a:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  5f:	eb 10                	jmp    71 <michael_setkey+0x25>
  61:	8b 12                	mov    (%edx),%edx
  63:	83 c0 30             	add    $0x30,%eax
  66:	89 50 08             	mov    %edx,0x8(%eax)
  69:	8b 53 04             	mov    0x4(%ebx),%edx
  6c:	89 50 0c             	mov    %edx,0xc(%eax)
  6f:	31 c0                	xor    %eax,%eax
  71:	5b                   	pop    %ebx
  72:	c3                   	ret    

00000073 <michael_init>:
  73:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
  7a:	c3                   	ret    

0000007b <michael_update>:
  7b:	55                   	push   %ebp
  7c:	89 c5                	mov    %eax,%ebp
  7e:	57                   	push   %edi
  7f:	83 c5 30             	add    $0x30,%ebp
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	89 cb                	mov    %ecx,%ebx
  86:	83 ec 08             	sub    $0x8,%esp
  89:	89 44 24 04          	mov    %eax,0x4(%esp)
  8d:	89 14 24             	mov    %edx,(%esp)
  90:	8b 75 04             	mov    0x4(%ebp),%esi
  93:	85 f6                	test   %esi,%esi
  95:	74 4c                	je     e3 <michael_update+0x68>
  97:	b8 04 00 00 00       	mov    $0x4,%eax
  9c:	29 f0                	sub    %esi,%eax
  9e:	39 c8                	cmp    %ecx,%eax
  a0:	89 c2                	mov    %eax,%edx
  a2:	0f 47 d1             	cmova  %ecx,%edx
  a5:	89 d1                	mov    %edx,%ecx
  a7:	8d 7c 35 00          	lea    0x0(%ebp,%esi,1),%edi
  ab:	8b 34 24             	mov    (%esp),%esi
  ae:	c1 e9 02             	shr    $0x2,%ecx
  b1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  b3:	89 d1                	mov    %edx,%ecx
  b5:	83 e1 03             	and    $0x3,%ecx
  b8:	74 02                	je     bc <michael_update+0x41>
  ba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  bc:	89 d0                	mov    %edx,%eax
  be:	03 45 04             	add    0x4(%ebp),%eax
  c1:	83 f8 03             	cmp    $0x3,%eax
  c4:	89 45 04             	mov    %eax,0x4(%ebp)
  c7:	76 4a                	jbe    113 <michael_update+0x98>
  c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  cd:	29 d3                	sub    %edx,%ebx
  cf:	01 14 24             	add    %edx,(%esp)
  d2:	8b 50 30             	mov    0x30(%eax),%edx
  d5:	89 e8                	mov    %ebp,%eax
  d7:	e8 24 ff ff ff       	call   0 <michael_block>
  dc:	c7 45 04 00 00 00 00 	movl   $0x0,0x4(%ebp)
  e3:	8b 34 24             	mov    (%esp),%esi
  e6:	eb 10                	jmp    f8 <michael_update+0x7d>
  e8:	83 c6 04             	add    $0x4,%esi
  eb:	89 e8                	mov    %ebp,%eax
  ed:	8b 56 fc             	mov    -0x4(%esi),%edx
  f0:	83 eb 04             	sub    $0x4,%ebx
  f3:	e8 08 ff ff ff       	call   0 <michael_block>
  f8:	83 fb 03             	cmp    $0x3,%ebx
  fb:	77 eb                	ja     e8 <michael_update+0x6d>
  fd:	85 db                	test   %ebx,%ebx
  ff:	74 12                	je     113 <michael_update+0x98>
 101:	89 5d 04             	mov    %ebx,0x4(%ebp)
 104:	31 c9                	xor    %ecx,%ecx
 106:	89 ef                	mov    %ebp,%edi
 108:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 10a:	89 d9                	mov    %ebx,%ecx
 10c:	83 e1 03             	and    $0x3,%ecx
 10f:	74 02                	je     113 <michael_update+0x98>
 111:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
 113:	58                   	pop    %eax
 114:	5a                   	pop    %edx
 115:	5b                   	pop    %ebx
 116:	5e                   	pop    %esi
 117:	5f                   	pop    %edi
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <michael_final>:
 11a:	56                   	push   %esi
 11b:	89 d6                	mov    %edx,%esi
 11d:	53                   	push   %ebx
 11e:	8d 58 30             	lea    0x30(%eax),%ebx
 121:	8b 43 04             	mov    0x4(%ebx),%eax
 124:	83 f8 02             	cmp    $0x2,%eax
 127:	74 14                	je     13d <michael_final+0x23>
 129:	83 f8 03             	cmp    $0x3,%eax
 12c:	74 16                	je     144 <michael_final+0x2a>
 12e:	48                   	dec    %eax
 12f:	ba 5a 00 00 00       	mov    $0x5a,%edx
 134:	b9 5a 00 00 00       	mov    $0x5a,%ecx
 139:	74 1b                	je     156 <michael_final+0x3c>
 13b:	eb 23                	jmp    160 <michael_final+0x46>
 13d:	b8 5a 00 00 00       	mov    $0x5a,%eax
 142:	eb 07                	jmp    14b <michael_final+0x31>
 144:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
 148:	80 cc 5a             	or     $0x5a,%ah
 14b:	89 c1                	mov    %eax,%ecx
 14d:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
 151:	c1 e1 08             	shl    $0x8,%ecx
 154:	09 c1                	or     %eax,%ecx
 156:	0f b6 03             	movzbl (%ebx),%eax
 159:	89 ca                	mov    %ecx,%edx
 15b:	c1 e2 08             	shl    $0x8,%edx
 15e:	09 c2                	or     %eax,%edx
 160:	89 d8                	mov    %ebx,%eax
 162:	e8 99 fe ff ff       	call   0 <michael_block>
 167:	89 d8                	mov    %ebx,%eax
 169:	31 d2                	xor    %edx,%edx
 16b:	e8 90 fe ff ff       	call   0 <michael_block>
 170:	8b 43 08             	mov    0x8(%ebx),%eax
 173:	89 06                	mov    %eax,(%esi)
 175:	8b 43 0c             	mov    0xc(%ebx),%eax
 178:	5b                   	pop    %ebx
 179:	89 46 04             	mov    %eax,0x4(%esi)
 17c:	5e                   	pop    %esi
 17d:	c3                   	ret    
Disassembly of section .init.text:

00000000 <michael_mic_init>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <michael_mic_init+0x6>
Disassembly of section .exit.text:

00000000 <michael_mic_exit>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <michael_mic_exit+0x6>

--=-1VZnPKTCgxVSgmOMPsqX--

