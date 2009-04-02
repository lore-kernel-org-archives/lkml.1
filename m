Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZDBPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZDBPdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762618AbZDBPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:33:09 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:31289 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756860AbZDBPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:33:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fe15mEFV8WXHZ3C66V5iMtCkRwC4n40tVmqciLMnHD57IXWmw39IBIa9o2/hysdsW0Cazy9QrUWfxEoiYvmMGQ2ARzZbV0XxLANIUy0h4JhM+tZ9c44r5/BMMNIO5b01GXw1U5mZgzcwx4bRYxsjZCH0pWQPqOl5hMw7p8Q43Do=  ;
X-YMail-OSG: ePbXAlwVM1mGnx8mwTB5bUlxhxip3ylQKYj23N9BfmCHnG0YmZGuUWgYMJRvsPoBUj7WvFq8gBap8RgpI6nSOwrU23MPkUYABXT5eDFAP2mVtKRRhZRS1cUp9fjFPxsamiKmtanJy3_ULiXF1KjgT_k91Cq9S659CawFjPhDa7Q9rHZemOquKCllrNY9sjGBBf6Rbgo1jXklirPVwVmVkcLCCqTUX8JRh8gVFWr.aKL4IYIxvLrr52_t_YciimdYkHzz7Lppz0inAFflZB3YHZu.Buu1OAJ7fqKyFRvQn_XT3od2Kq.Q0nVxAf.27vWGpb2jA2v15WTZxkDrXxLR4nJ3GQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Fri, 3 Apr 2009 02:32:58 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200904030100.05741.nickpiggin@yahoo.com.au> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk> <5564.1238684153@redhat.com>
In-Reply-To: <5564.1238684153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030232.59355.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 01:55:53 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > > Hook the Ext2 and Ext3 operations to the generic implementation.
> > 
> > Is this really worthwhile?
> 
> I seem to remember being told that I'm not allowed to call such directly (by
> Christoph Hellwig perhaps?), and that I should add an address space op to do
> this.

Hmm, I guess not all filesystems define write_begin/write_end. But if you
only need to use ones that do define them?

>
> > What do you do that write_begin/write_end doesn't?
> 
> This code calls write_begin() and write_end().

Yes, you framed the changelog as introducing this new callback because it
allows a highly optimised code that takes advantage of page aligned write.
So I went on a tangent thinking you were going to use it later to avoid
the data copy or something.

 
> write_begin() and write_end() don't actually update the target page, and don't
> so the osync stuff.
> 
> My code assumed file can be passed as NULL to write_begin() and write_end().
> If file is, however, necessary then the backing fs can do something different.
> cachefiles doesn't know.

You are knowingly squashing together fscache and the backing filesystem if
you do something like introduce a flag like PG_owner_priv_2 and disallow the
backing filesystem from reusing it. So at which point you don't have to keep
up illusions about being totally filesystem agnostic.

Many filesystems don't need the file argument to write_begin/write_end.
