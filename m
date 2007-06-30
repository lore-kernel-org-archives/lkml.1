Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbXF3ImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbXF3ImX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 04:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXF3ImM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 04:42:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXF3ImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 04:42:10 -0400
Date: Sat, 30 Jun 2007 09:42:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, jlayton@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] CIFS: make cifsd (more)
Message-ID: <20070630084209.GA21186@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>, linux-fsdevel@vger.kernel.org,
	jlayton@redhat.com, linux-kernel@vger.kernel.org,
	linux-cifs-client@lists.samba.org, netdev@vger.kernel.org
References: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 05:25:00PM -0500, Steve French wrote:
> Jeff,
> Not seeing any objections to your revised approach (to not allowing
> signals for cifsd kernel thread), I just merged something similar to
> your patch to the cifs-2.6.git tree (also fixed some nearby lines that
> went past 80 columns).

Ok, I'm back to this.

As I said mixing force_sig with the kthread infrastructure is a bad idea.
The proper short-term (aka 2.6.22) fix is to revert the kthread conversion
for this particular thread.  Just go back to what worked before.

Now the right fix is a lot more complicated and involved:

	Stop using blocking recvmsg (or read) in kernel threads!

If you look at what the other consumers of networking reads from kernel
threads do is they either use tcp_read_sock and hooks into the sk_ callbacks
which would be nice for high performance reads in cifs aswell, but probably
not the demultiplexer thread, or they use MSG_DONTWAIT to avoid this problems
and deal with the blocking behaviour on a higher level.
