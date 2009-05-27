Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZE0Jzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZE0Jzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbZE0Jzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:55:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZE0Jzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:55:45 -0400
Date: Wed, 27 May 2009 05:55:33 -0400
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
Message-ID: <20090527095532.GA17236@infradead.org>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <20090526060232.GA10669@infradead.org> <4A1C9AC4.3090704@cn.fujitsu.com> <20090527072956.GC24381@infradead.org> <4A1CF5F2.6050209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1CF5F2.6050209@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:12:34PM +0800, Li Zefan wrote:
> >         TP_fast_assign(
> > 		__entry->ino = args->dp->i_ino;
> > 		if (args->namelen)
> > 			memcpy(__entry->name, args->name,
> > 			       min(args->namelen, TRACE_MAXNAMELEN));
> 
> This string is not NULL-terminated?

As written a little above it's indeed not NULL-terminated.

> Then the above code can be rewrote:
> 
> TRACE_EVENT(xfs_dir2,
> 	TP_PROTO(struct xfs_da_args *args, int i, int j, int count),
> 	TP_ARGS(args, i, j, count),
> 
> 	TP_STRUCT__entry(
> 		__field(xfs_ino_t, ino)
> 		__string(name, args->namelen)
> 		__field(int, namelen)
> 		...
> 	),
> 
>         TP_fast_assign(
> 		__entry->ino = args->dp->i_ino;
> 		memcpy(__fetch_str(name), args->name, args->namelen);
> 		__entry->namelen = args->namelen;
> 		...
> 	),
> 
> 	TP_printk("ino 0x%lld %pF name %.*s namelen %d hashval 0x%x "
> 		  "inumber 0x%llx op_flags %s i %d j %d count %d",
> 		  __entry->ino,
> 		  (void *)__entry->caller_ip,
> 		  __entry->namelen,
> 		  __get_str(name),
> 		  __entry->namelen,

That's indeed wht I would love to see.
