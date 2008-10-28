Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYJ1UTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYJ1UTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYJ1UTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:19:37 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53384 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752956AbYJ1UTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:19:35 -0400
Date: Tue, 28 Oct 2008 21:19:33 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>, akpm@linux-foundation.org,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 02/16] Squashfs: directory lookup operations
In-Reply-To: <4907566D.9040003@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0810282118360.25466@vixen.sonytel.be>
References: <E1KqrTW-0001xG-Cl@dylan> <Pine.LNX.4.64.0810281835150.23080@vixen.sonytel.be>
 <4907566D.9040003@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-435637623-1225225173=:25466"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-435637623-1225225173=:25466
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 28 Oct 2008, Michael Tokarev wrote:
> Geert Uytterhoeven wrote:
> > On Fri, 17 Oct 2008, Phillip Lougher wrote:
> > > --- /dev/null
> > > +++ b/fs/squashfs/namei.c
> > 
> > > +static int get_dir_index_using_name(struct super_block *s,
> > > +			long long *next_block, unsigned int *next_offset,
> > > +			long long index_start, unsigned int index_offset,
> > > +			int i_count, const char *name, int len)
> > > +{
> > > +	struct squashfs_sb_info *msblk = s->s_fs_info;
> > > +	int i, size, length = 0;
> > > +	struct squashfs_dir_index *index;
> > > +	char *str;
> > > +
> > > +	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
> > > +
> > > +	str = kmalloc(sizeof(*index) + (SQUASHFS_NAME_LEN + 1) * 2,
> > > GFP_KERNEL);
> > > +	if (str == NULL) {
> > > +		ERROR("Failed to allocate squashfs_dir_index\n");
> > > +		goto out;
> > > +	}
> > > +
> > > +	index = (struct squashfs_dir_index *) (str + SQUASHFS_NAME_LEN + 1);
> > 
> > As str has been returned by kmalloc(), and SQUASHFS_NAME_LEN is equal to
> > 256,
> > `str + SQUASHFS_NAME_LEN + 1` is an odd address.
> > 
> [..]
> > > +		size = le32_to_cpu(index->size) + 1;
> >                                    ^^^^^^^^^^^
> [.]
> > Hence accessing multi-byte fields in struct squashfs_dir_index causes
> > unaligned
> > accesses, which are emulated on some architectures (e.g. on MIPS).
> > 
> > Use get_unaligned_le32() for unaligned accesses.
> 
> How about aligning it properly in the first place instead?
> Three ways:
> 
>   1) reordering index and str here, so that index comes first,
>      str next.
> 
>   2) using another constant instead of +1
> 
>   3) using separate allocations for separate objects.

You're right.

Somehow I was convinced this was part of the on-disk layout, so it could not be
changed. But that's not the case...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-435637623-1225225173=:25466--
