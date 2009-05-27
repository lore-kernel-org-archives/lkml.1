Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZE0Hgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZE0Hgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762877AbZE0Haj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:30:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762872AbZE0Hah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:30:37 -0400
Date: Wed, 27 May 2009 03:30:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
Message-ID: <20090527072956.GC24381@infradead.org>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <20090526060232.GA10669@infradead.org> <4A1C9AC4.3090704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1C9AC4.3090704@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:43:32AM +0800, Li Zefan wrote:
> I'm not suffering from NULL str, so I'm not quite sure how you want __string()
> deal with it.

The internals of __string is still magic to me, need to finish my
advance cpp abuse degree first ;-)

But the expected outcome would be that when we get a NULL pointer as
input we get a NULL pointer as output again.

What I currently do is:

TRACE_EVENT(xfs_dir2,
	TP_PROTO(struct xfs_da_args *args, int i, int j, int count),
	TP_ARGS(args, i, j, count),

	TP_STRUCT__entry(
		__field(xfs_ino_t, ino)
		__array(char, name, TRACE_MAXNAMELEN)
		__field(int, namelen)
		...
	),

        TP_fast_assign(
		__entry->ino = args->dp->i_ino;
		if (args->namelen)
			memcpy(__entry->name, args->name,
			       min(args->namelen, TRACE_MAXNAMELEN));
		__entry->namelen = args->namelen;
		...
	),

	TP_printk("ino 0x%lld %pF name %.*s namelen %d hashval 0x%x "
		  "inumber 0x%llx op_flags %s i %d j %d count %d",
		  __entry->ino,
		  (void *)__entry->caller_ip,
		  min(__entry->namelen, TRACE_MAXNAMELEN),
		  __entry->namelen ? __entry->name : NULL,
		  __entry->namelen,
		  ...)
);

> 
> 
---end quoted text---
