Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZBMWHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZBMWHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZBMWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:07:08 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:38459 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZBMWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sJcgOKmQofXXhMw5LzYXeVT2STRNU6U5ydL3UFQNyovnBfhkLP/R1Ua/9UkFcJXYQj
         vraZert81ugu1QE/vxLjcXyY4JdQTdg3VlDhC5dcJ3m/EvMrMSE5z1o/NXfpMwLELaBv
         XYZA2KAzbDnjikvoWz1Y74VY4dyfT6SSBicjo=
Subject: Re: get/put unaligned helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20090211143521.GA18866@lst.de>
References: <20090211143521.GA18866@lst.de>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 14:07:02 -0800
Message-Id: <1234562823.5521.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 15:35 +0100, Christoph Hellwig wrote:
> I just loked into using the new get/put unaligned helpers.  I must
> say that I'm really unhappy about the lack of typing there.  We did
> put all the sparse infrastructure in place to make sure we do have
> strong typechecking for LE/Be types, but using these helpers defeats
> that.
> 
> Can you please make these properly typed?

Christoph, here's a quick summary of comments on the unaligned access bits
I've previously submitted, please let me know if you have any additional ones.

Proposed API:

u16 load_le16_noalign(const __le16 *p)
u32 load_le32_noalign(const __le32 *p)
u64 load_le64_noalign(const __le64 *p)
u16 load_be16_noalign(const __be16 *p)
u32 load_be32_noalign(const __be32 *p)
u64 load_be64_noalign(const __be64 *p)

void store_le16_noalign(__le16 *p, u16 val)
void store_le32_noalign(__le32 *p, u32 val)
void store_le64_noalign(__le64 *p, u64 val)
void store_be16_noalign(__be16 *p, u16 val)
void store_be32_noalign(__be32 *p, u32 val)
void store_be64_noalign(__be64 *p, u64 val)

I'd also like to offer aligned versions like load_le16() store_le16()
to make it symmetric.  Then for arches that have no alignment constraints
the unaligned helpers would degrade to the aligned helpers.  load_le16()
already exists as le16_to_cpup, but store_le16 would be a new API.

Now, from discussions with the SCSI-folks, they really aren't interested in a
typesafe interface as most of the time they are reading/writing into a u8 buffer
at some offset.  It seems a lot of the other places currently in-kernel also
do the same.  So I'm tempted to keep offering a version wrapped around the
typesafe versions that takes a u8 *.

As they were not interested in doing the following:

load_be16_noalign((__be16 *)&buf[offset]);

Perhaps a wrapper could be provided:

load_be16_offset(u8 *buf, int offset)

Thoughts?

Harvey

