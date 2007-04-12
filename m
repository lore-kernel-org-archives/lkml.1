Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXDLT1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXDLT1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXDLT1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:27:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:30038 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXDLT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A1/rp3BRTHo67QL64bN8NabNPzv9Ao/GsGZHSNXM4gwPuev1hlfsgsPZGN91d289JfacsehkuM4o5PZR+qKTKBaoKIWZ2kd+/1X1V+JCRVUvXadC2v6o9pdWPKiBXd6yP/nudZ5E9l4cR5ke/8Efk4GAeSBOzVwDkM6OuP9IDxs=
Message-ID: <5c49b0ed0704121227h48c3271bp2511e082704d639f@mail.gmail.com>
Date: Thu, 12 Apr 2007 12:27:07 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
In-Reply-To: <29898.1176404243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412024938.27380.44677.patchbomb.py@localhost>
	 <1273.1176375482@redhat.com>
	 <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com>
	 <29898.1176404243@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, David Howells <dhowells@redhat.com> wrote:
> Nate Diller <nate.diller@gmail.com> wrote:
>
> > Hmmm you're right.  Is your security work going into the next -mm?
>
> I don't know.  Andrew hasn't said anything.  Andrew?  Are you waiting for it
> to go through DaveM's networking tree?
>
> > If so, I'll just re-base this cleanup patch on that ... at the very least I
> > want to get rid of afs_dir_put_page().
>
> That's reasonable.
>
> > Also, did you consider passing the key pointer directly and modifying the
> > readpage actor to simply cast the pointer back, like
> > read_mapping_page(mapping, page, (struct file *)key)?  It seems like a waste
> > to allocate a whole file struct on the stack just for the ->private field.
>
> There's one small problem with that...  And that's filemap_nopage() (it passes
> vma->vm_file to readpage() unconditionally).  Unless, of course, your patches
> fix that too...

But you can't mmap() a directory anyway so ... oh.  Interesting.
afs_file_readpage() does directories too.  The only thing I can think
of then is

struct address_space_operations afs_file_aops = {
        .readpage       = afs_file_readpage,
}
struct address_space_operations afs_dir_aops = {
        .readpage       = afs_key_readpage,
}

int afs_file_readpage(file, page){
    return afs_key_readpage(file->private, page)
}

but that's a lot of code to avoid a single stack allocation.  The
whole fake file pointer thing still strikes me as a little ugly, and
you're definitely not the first one who needed this sort of hackery.
ugh

NATE
