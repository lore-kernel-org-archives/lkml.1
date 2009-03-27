Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbZC0M3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbZC0M3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZC0M3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:29:34 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:17863 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZC0M3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:29:34 -0400
X-Greylist: delayed 715 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 08:29:33 EDT
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXcZSc7aQIr
X-RZG-CLASS-ID: mo05
Message-ID: <49CCC3DE.7070104@ursus.ath.cx>
Date: Fri, 27 Mar 2009 13:17:34 +0100
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>
Subject: Re: Linux 2.6.29 - delayed metadata for delayed allocation?
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
In-Reply-To: <20090327112438.GQ6239@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-03-27 at 12:24 Theodore Tso wrote:
> When I was growing up we were trained to *always* check error returns
> from *all* system calls, and to *always* fsync() if it was critical
> that the data survive a crash.
But there are a lot of applications for which the survival of the data
is not this critical as long as the old data is still available.

Data are the important stuff, metadata helps to find them. Even though
there are a lot of cases, where the information is just stored in the
metadata.
If you write metadata for not-yet-existing data to disk, then these are
inconsistent, corrupt, dirty.

Why don't you just delay the writing of these dirty metadata, too, until
they are clean? So nothing is written until the next sync and then

1) write the data to the nicely allocated places.
2) journal the metadata for consistency
3) write the metadata
4) cleanup the journal

That way you can have sophisticated allocation and keep a consistent
filesystem without data loss due to re-ordering.

Clean metadata-changes which don't have delayed data might be
written/journaled immediately. That rises the question, whether dirty
metadata changes should be skipped or whether a dirty metadata change
should block later clean metadata changes to inhibit the re-ordering of
changes. This should be a mount-option IMHO. Keeping the order of
fs-changes has a big advantage in many cases.

Syncing data on renames would decrease your performance which you want
to increase with delayed allocation. Delayed metadata would mostly keep
this performance gain, right?

Andreas





