Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXH1UFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXH1UFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXH1UE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:04:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbXH1UE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:04:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xDbY/Ob/abtHKArdxoUzW3jBJrNpqYXQarTjs/CVzzUyg2X0GXaoGqYo8cekwhRZZ
	eOgM9Q5dklZq7CktHPgOg==
Message-ID: <6599ad830708281304m18a34ab5m96692eafc55e3c57@mail.gmail.com>
Date: Tue, 28 Aug 2007 13:04:34 -0700
From: "Paul Menage" <menage@google.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [-mm PATCH 5/10] Memory controller task migration (v7)
Cc: balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, npiggin@suse.de,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, ebiederm@xmission.com,
       containers@lists.osdl.org, xemul@openvz.org
In-Reply-To: <20070828083252.C7D5C1BFA2F@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D2A9D3.50703@linux.vnet.ibm.com>
	 <20070828083252.C7D5C1BFA2F@siro.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
>
> although i have no good idea right now, something which allows
> to move a process with its thread group leader dead would be better.
>

One way I was thinking of approaching this problem was slightly different:

- every mm always has an "owning" task. Initially that will be the
thread that creates the mm

- if the owning thread exits or execs and *isn't* the last user of the
mm, then we may need to find a new owner for the mm:

1) My guess is that typically the thread that created the mm will also
be the last user of the mm - if this is the case, then in the normal
case we don't need to find a new owner.

2) If we do need a new owner, first look amongst the other threads in
the process (cheap, should find another user of the mm quickly)

3) next look in the child and parent threads (more expensive, but rarer)

4) if necessary, scan the entire thread list (expensive, but should
never be needed in general use)

The advantage of this is that we don't then need to have a memory
container pointer in the mm - we can just use the memory container of
the mm's owner.

With just a single container type needing to be tied to an mm, this
isn't a huge advantage since we're just replacing one pointer (memory
container) with another (owning task) and have similar levels of
complexity for both. But if we have multiple container subsystems that
need to be tied to a particular mm then they can both use the mm owner
pointer.

E.g. I want to add a swap container subsystem that restricts which
swap devices a group of processes can swap to, and how many pages they
can put into swap. And I want to be able to run this independently of
the in-memory page accounting subsystem. Having a task owner pointer
in the mm allows these to be indpendent subsystems, and (I believe)
isn't any more complex than the work involved to support moving an mm
whose thread group leader has exited or execd.

Paul
