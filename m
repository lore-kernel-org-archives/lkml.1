Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYIJFbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYIJFbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYIJFbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:31:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYIJFbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:31:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Lf/hUU2kIc1F9ZVcNQ2kwatI8V76tzksucqYTZJ51jrmG2N1q6JbfhtQBxqw4Yx7w
	QJ/yFp0k1ygIy//cFSb7g==
Message-ID: <6599ad830809092231h90712a6mc95b81229d64d6bc@mail.gmail.com>
Date: Tue, 9 Sep 2008 22:31:24 -0700
From: "Paul Menage" <menage@google.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and find_css_set
Cc: "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910050112.GA2897@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AA684B.7000704@cn.fujitsu.com>
	 <6599ad830809091728m426a7219h1977001f86cb5f31@mail.gmail.com>
	 <48C72E7C.8080302@cn.fujitsu.com> <20080910050112.GA2897@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
>
> What are you trying to solve here with this change?  I agree, it does
> seem a bit "chaotic" :)

There's a place in cgroups that uses kref_put() to release an object;
the release function *then* takes a write-lock and removes the object
from a lookup table; it could race with another thread that searches
the lookup table (while holding a read-lock) and does kref_get() on
the same object.

The current fix is for the release function to recheck inside the lock
that the object's refcount is still zero, and only actually
unlink/free it if so. And actually I've just realised that this isn't
actually even safe, since the thread that just acquired the object
could kref_put() it almost immediately, which would leave two threads
both trying to unlink/free the object.

The two solutions being considered are:

- add a kref_put_and_write_lock(), similar to atomic_dec_and_lock(),
which would ensure that the final refcount on the object was only
released inside the lock

- add a kref_get_if_not_zero(), which would prevent a lookup from
succeeding if another thread had just dropped the last reference on
the object.

Paul
