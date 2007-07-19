Return-Path: <linux-kernel-owner+w=401wt.eu-S938730AbXGSPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938730AbXGSPL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbXGSPLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:11:47 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:47005 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbXGSPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DdZV2H5QStfSmsj0XTm4CG5oLALgHmaLuBEObi9e3ZTfNLvefepohd2E/eAkOTSMMNanOKdrnPtJmyUHaXvosgwkWgL6P5ae+D6PIYG2Kra7zEzT0rVC1Mw1gkqSj39OWT5ZN56Jrbw9Sytp3lpaqt0Kv9wJaM7RbqzcVyyplHA=
Message-ID: <a781481a0707190811y725ac900m13e9b6a02eab7b0@mail.gmail.com>
Date: Thu, 19 Jul 2007 20:41:44 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Cc: "David CHANIAL" <david.ml@euro-web.fr>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707190711s58d7ab24xa53c6975d4172597@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707160638.15750.david.ml@euro-web.fr>
	 <18076.42052.961808.528867@notabene.brown>
	 <a781481a0707190711s58d7ab24xa53c6975d4172597@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, not a good day for me today ... my earlier conclusion was right,
but not the reasoning behind it ... hopefully this time I'll do better :-)


On 7/19/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Neil,
>
> [ okay, just searching through my lkml folder looking for
> "unable to handle" :-) ]
>
> On 7/17/07, Neil Brown <neilb@suse.de> wrote:
> > On Monday July 16, david.ml@euro-web.fr wrote:
> > >
> > > ************
> > > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > > 00000004
>
> > > EIP is at encode_fsid+0x67/0x89
> >
> > This is presumably where the illegal access happened.
> >
> > > eax: e5bde8c0   ebx: f7593404   ecx: 00000000   edx: 00000006
> > > esi: dc569048   edi: f75934ec   ebp: f7593404   esp: f75f1f18
>
> Yup, ecx is to blame here ...
>
> > > Code: e2 08 09 d1 09 c1 eb 10 8b 83 88 00 00 00 8b 40 30 89 c3 89 c1 c1 fb 1f
> > > 89 d8 0f c8 89 06 89 c8 eb 1e
> >
> > Unfortunately "ksymoops" does seem to decode this into something quite
> > useful enough.  Normally one of the numbers has <> around it.  Are you
> > should you copied the number across exactly?
>
> Yes, I think David missed posting the full "Code:" here. Unfortunate.
>
> >  In any case, there is no place in encode_fsid where an offset of 4
> >  from any register is indexed, nor an offset of -2.
>
> But I went ahead and disassembled encode_fsid() anyway. I did
> stumble across a "mov 0x4(%ecx), %edx" -- which turns out to be:
>
> static __be32 *encode_fsid(__be32 *p, struct svc_fh *fhp)
> {
>         u64 f;
>         switch(fsid_source(fhp)) {
>         default:
>         case FSIDSOURCE_DEV:
>                 p = xdr_encode_hyper(p, (u64)huge_encode_dev
>                                 (fhp->fh_dentry->d_inode->i_sb->s_dev));
>                 break;
>         case FSIDSOURCE_FSID:
>                 p = xdr_encode_hyper(p, (u64) fhp->fh_export->ex_fsid);
>                 break;
>         case FSIDSOURCE_UUID:

Whoops ...

>                 f = ((u64*)fhp->fh_export->ex_uuid)[0]; /* *** HERE *** */
>                 f ^= ((u64*)fhp->fh_export->ex_uuid)[1]; /* and not here */

Anyway, %ecx is fhp->fh_export->ex_uuid above. (NULL, therefore 0).

f is u64, so on 32-bit i386, we need to store it in two local registers.
gcc does that by fetching 0x4(%ecx) into one register, and (%ecx)
into another, both those combined is the first memory load into f.

For the second memory load, again it's a (u64 *) cast, so gcc will
fetch 0xc(%ecx) and 0x8(%ecx) separately into two local registers.

And then xor them _separately_. (upper word with upper word,
lower word with lower word)

>                 p = xdr_encode_hyper(p, f);

These are probably the ntohl's -> bswap's.

>                 break;
>         }
>         return p;
> }
>
> Note that fhp->fh_export->ex_uuid is an unsigned char *, which is
> 4 bytes on an i386 (which is what David's system is).

So this wasn't quite right.

> For some
> reason fhp->fh_export->ex_uuid (%ecx) is NULL here, which leads
> to the oops. I have _zero_ other knowledge of knfsd code, and
> not really be of any other use, sorry.

But this was.

nfs3xdr.o:     file format elf32-i386
Disassembly of section .text:
00000232 <encode_fsid>:
     232:	55                   	push   %ebp
     233:	89 e5                	mov    %esp,%ebp
     235:	57                   	push   %edi
     236:	56                   	push   %esi
     237:	89 c6                	mov    %eax,%esi
     239:	53                   	push   %ebx
     23a:	89 d0                	mov    %edx,%eax
     23c:	89 d3                	mov    %edx,%ebx
     23e:	e8 fc ff ff ff       	call   23f <encode_fsid+0xd>
     243:	83 f8 01             	cmp    $0x1,%eax
     246:	74 3e                	je     286 <encode_fsid+0x54>
     248:	83 f8 02             	cmp    $0x2,%eax
     24b:	8d 7e 08             	lea    0x8(%esi),%edi

Note the lea 0x8(%esi),%edi here.

These are the other cases below.

     24e:	74 56                	je     2a6 <encode_fsid+0x74>
     250:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
     256:	31 db                	xor    %ebx,%ebx
     258:	8b 40 24             	mov    0x24(%eax),%eax
     25b:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
     261:	8b 50 08             	mov    0x8(%eax),%edx
     264:	89 d0                	mov    %edx,%eax
     266:	0f b6 ca             	movzbl %dl,%ecx
     269:	c1 e8 14             	shr    $0x14,%eax
     26c:	81 e2 00 ff 0f 00    	and    $0xfff00,%edx
     272:	c1 e0 08             	shl    $0x8,%eax
     275:	09 c1                	or     %eax,%ecx
     277:	89 d8                	mov    %ebx,%eax
     279:	c1 e2 0c             	shl    $0xc,%edx
     27c:	09 d1                	or     %edx,%ecx
     27e:	0f c8                	bswap  %eax
     280:	89 06                	mov    %eax,(%esi)
     282:	89 c8                	mov    %ecx,%eax
     284:	eb 3e                	jmp    2c4 <encode_fsid+0x92>
     286:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
     28c:	8b 48 30             	mov    0x30(%eax),%ecx
     28f:	89 cb                	mov    %ecx,%ebx
     291:	c1 fb 1f             	sar    $0x1f,%ebx
     294:	89 d8                	mov    %ebx,%eax
     296:	0f c8                	bswap  %eax
     298:	89 06                	mov    %eax,(%esi)
     29a:	89 c8                	mov    %ecx,%eax
     29c:	0f c8                	bswap  %eax
     29e:	89 46 04             	mov    %eax,0x4(%esi)
     2a1:	8d 46 08             	lea    0x8(%esi),%eax
     2a4:	eb 25                	jmp    2cb <encode_fsid+0x99>

Okay, this is case FSIDSOURCE_UUID:

     2a6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax

0x88 bytes is the offset of struct fh_export * in struct svc_fh.

     2ac:	8b 48 34             	mov    0x34(%eax),%ecx

0x34 bytes is the offset of ex_uuid in struct fh_export.
%ecx == 0, which means ex_uuid was NULL.

     2af:	8b 51 04             	mov    0x4(%ecx),%edx

Upper word of: ((u64*)fhp->fh_export->ex_uuid)[0]

     2b2:	8b 59 0c             	mov    0xc(%ecx),%ebx

Upper word of: ((u64*)fhp->fh_export->ex_uuid)[1]

     2b5:	8b 01                	mov    (%ecx),%eax

Lower word of: ((u64*)fhp->fh_export->ex_uuid)[0]

     2b7:	8b 49 08             	mov    0x8(%ecx),%ecx

Lower word of: ((u64*)fhp->fh_export->ex_uuid)[1]

     2ba:	31 da                	xor    %ebx,%edx

Xor upper with upper.

     2bc:	31 c8                	xor    %ecx,%eax

Xor lower with lower.

So now we finally have the "f ^= ..." thing in %eax and %edx.
%eax is lower, %edx is the upper word of "f".

     2be:	89 d1                	mov    %edx,%ecx

gcc moves %edx to %ecx just for kicks.
So now the upper word of "u64 f" is in %ecx.

Looks like xdr_encode_hyper got inlined below.

     2c0:	0f c9                	bswap  %ecx

htonl(upperword)

     2c2:	89 0e                	mov    %ecx,(%esi)

Store that in *p.

     2c4:	0f c8                	bswap  %eax

htonl(lowerword)

     2c6:	89 46 04             	mov    %eax,0x4(%esi)

p++ and store it there in *p.

     2c9:	89 f8                	mov    %edi,%eax

As we noted the "lea 0x8(%esi),%edi" up above, %edi is precisely the
operation that does p++ as well as puts return value (__be32 *p) in %eax.

     2cb:	5b                   	pop    %ebx
     2cc:	5e                   	pop    %esi
     2cd:	5f                   	pop    %edi
     2ce:	5d                   	pop    %ebp
     2cf:	c3                   	ret

And we return.


Ahhh ... gcc generated some _beautiful_ code up there. Didn't find
a single instruction that shouldn't have been ...


Satyam
