Return-Path: <linux-kernel-owner+w=401wt.eu-S1423661AbXEAVXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423661AbXEAVXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423667AbXEAVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:23:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423661AbXEAVXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:23:36 -0400
Date: Tue, 1 May 2007 14:23:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cabot, Mason B" <mason.b.cabot@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Ext3 vs NTFS performance
Message-Id: <20070501142325.09c294bd.akpm@linux-foundation.org>
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 13:43:18 -0700
"Cabot, Mason B" <mason.b.cabot@intel.com> wrote:

> Hello all,
> 
> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.

Oh my gawd, what a stupid hack.  Now we know what the MS interoperability
lab has been working on.

> I've posted a brief paper on Intel's OSS website
> (http://softwarecommunity.intel.com/articles/eng/1259.htm). Please give
> it a read and let me know what you think. In particular, I'd like to
> arrive at the right place to fix this problem: is it in the filesystem,
> VFS, or Samba?

Conceivably we could address this in the filesystem without mucking other
things up.  But I'd have thought the simplest damage-control would be to
detect this pattern in samba and to then use glibc's fallocate().

At present glibc will emulate fallocate() by writing zeroes.  There are
patches floating about to implement fallocate in-kernel and if/when that
turns up and is supported in glibc, the modified samba will automatically
start to use it.

Are you sure there isn't some registry setting to prevent the CIFS client
from doing the client-side preallocation?
