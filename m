Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZDNUEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZDNUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZDNUDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:03:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZDNUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:03:52 -0400
To: jamie@shareable.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, mfasheh@suse.com,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090414182242.GG32311@shareable.org> (message from Jamie Lokier
	on Tue, 14 Apr 2009 19:22:42 +0100)
Subject: Re: [patch 5/6] splice: remove generic_file_splice_write_nolock()
References: <20090414174835.487031939@szeredi.hu> <20090414174859.496563416@szeredi.hu> <20090414182242.GG32311@shareable.org>
Message-Id: <E1Ltoqx-0006MK-Ma@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 14 Apr 2009 22:03:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Jamie Lokier wrote:
> Miklos Szeredi wrote:
> > Remove the now unused generic_file_splice_write_nolock() function.
> > It's conceptually broken anyway, because splice may need to wait for
> > pipe events so holding locks across the whole operation is wrong.
> 
> Did the conceptual brokenness affect userspace behaviour of
> splice/sendfile at all?

Splice: yes, sendfile: no.  Sendfile uses an internal pipe and it
always makes sure there's no blocking on that pipe.

With splice it's up to the process feeding the pipe to make sure there
are buffers for the splice to consume.  If it the pipe is not fed
properly then the splice call might hang, waiting for data, keeping
any locks surrounding generic_file_splice_write_nolock() locked.
Which in turn will block other operations from proceeding.  Not what
we want.

Thanks,
Miklos
