Return-Path: <linux-kernel-owner+w=401wt.eu-S1765329AbZDBQ3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765329AbZDBQ3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764993AbZDBQ3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:29:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759906AbZDBQ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:29:24 -0400
Subject: Re: Issues with using fanotify for a filesystem indexer
From: Alexander Larsson <alexl@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090402145457.GA17275@atrey.karlin.mff.cuni.cz>
References: <1238158043.23703.20.camel@fatty>
	 <20090402145457.GA17275@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 02 Apr 2009 18:29:04 +0200
Message-Id: <1238689744.5704.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 16:54 +0200, Jan Kara wrote:

>   Some time ago I was trying to solve a similar problem and I've come up
> with a solution which I've called recursive mtime. The general idea is
> that with each directory, kernel additionally keeps a flag and a
> timestamp. When a directory is modified, we do:
>   dir = changed dir;
>   while dir has flag set do
>     update timestamp to current time
>     clear flag
>     dir = parent dir
> 
>   When a file is modified, you just start with a parent directory of
> that file. With this scheme, you are able to find reasonably quickly
> (without looking at unchanged directories) what has changed since
> you've looked last time (you look for timestamps newer than the time
> when you started last scan and you set flags as you go). Also the scheme
> is quite cheap to maintain and has no problems with overflowing event
> queues etc. (observe that the scheme works perfectly fine for several
> independent scanners in parallel). As a bonus, if you store the flag +
> timestamp persistently on disk, you can use this scheme to speedup things
> like rsync.
>   What gets nasty (but solvable) are hardlinks and bind mounts. I was
> writing a library to handle these last summer but then had to work on
> something else and didn't get back to it yet.

Another potential issue with this is that every change bubbles up to the
top, modifying the recursive mtime of that. This will become very
contented, and may imply a partial serialization of fs activity, which
is kinda costly.

