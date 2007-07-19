Return-Path: <linux-kernel-owner+w=401wt.eu-S965502AbXGSOQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbXGSOQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939167AbXGSOLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:11:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:33422 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939166AbXGSOLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=deiJBAludcFTXuhcJp69bxE3wFDZd8aZ+rstbLWkEz8c6agvcMvglMAZw7UZSZhmu/C0tJy0WJ7Ole7khVeUu+spoArn/gAaPiYhonZKLO/rZJBfkQJuxMS7GHQ2ulq5FDFAQVSd7YrLnF0Si+OjE9zv/FXF12Z/4Gcn2LA9Wug=
Message-ID: <a781481a0707190711s58d7ab24xa53c6975d4172597@mail.gmail.com>
Date: Thu, 19 Jul 2007 19:41:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference - nfs v3
Cc: "David CHANIAL" <david.ml@euro-web.fr>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>
In-Reply-To: <18076.42052.961808.528867@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707160638.15750.david.ml@euro-web.fr>
	 <18076.42052.961808.528867@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

[ okay, just searching through my lkml folder looking for
"unable to handle" :-) ]

On 7/17/07, Neil Brown <neilb@suse.de> wrote:
> On Monday July 16, david.ml@euro-web.fr wrote:
> >
> > ************
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000004

> > EIP is at encode_fsid+0x67/0x89
>
> This is presumably where the illegal access happened.
>
> > eax: e5bde8c0   ebx: f7593404   ecx: 00000000   edx: 00000006
> > esi: dc569048   edi: f75934ec   ebp: f7593404   esp: f75f1f18

Yup, ecx is to blame here ...

> > Code: e2 08 09 d1 09 c1 eb 10 8b 83 88 00 00 00 8b 40 30 89 c3 89 c1 c1 fb 1f
> > 89 d8 0f c8 89 06 89 c8 eb 1e
>
> Unfortunately "ksymoops" does seem to decode this into something quite
> useful enough.  Normally one of the numbers has <> around it.  Are you
> should you copied the number across exactly?

Yes, I think David missed posting the full "Code:" here. Unfortunate.

>  In any case, there is no place in encode_fsid where an offset of 4
>  from any register is indexed, nor an offset of -2.

But I went ahead and disassembled encode_fsid() anyway. I did
stumble across a "mov 0x4(%ecx), %edx" -- which turns out to be:

static __be32 *encode_fsid(__be32 *p, struct svc_fh *fhp)
{
	u64 f;
	switch(fsid_source(fhp)) {
	default:
	case FSIDSOURCE_DEV:
		p = xdr_encode_hyper(p, (u64)huge_encode_dev
				(fhp->fh_dentry->d_inode->i_sb->s_dev));
		break;
	case FSIDSOURCE_FSID:
		p = xdr_encode_hyper(p, (u64) fhp->fh_export->ex_fsid);
		break;
	case FSIDSOURCE_UUID:
		f = ((u64*)fhp->fh_export->ex_uuid)[0];
		f ^= ((u64*)fhp->fh_export->ex_uuid)[1]; /* ***** HERE ***** */
		p = xdr_encode_hyper(p, f);
		break;
	}
	return p;
}

Note that fhp->fh_export->ex_uuid is an unsigned char *, which is
4 bytes on an i386 (which is what David's system is). For some
reason fhp->fh_export->ex_uuid (%ecx) is NULL here, which leads
to the oops. I have _zero_ other knowledge of knfsd code, and
not really be of any other use, sorry.

Satyam
