Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZFKTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZFKTUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZFKTUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:20:45 -0400
Received: from thunk.org ([69.25.196.29]:45926 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZFKTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:20:44 -0400
Date: Thu, 11 Jun 2009 15:20:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
Message-ID: <20090611192037.GA5116@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Zhaolei <zhaolei@cn.fujitsu.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jason Baron <jbaron@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>,
	Tom Zanussi <tzanussi@gmail.com>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com> <20090610160303.GA10240@mit.edu> <20090611130318.GB14220@infradead.org> <20090611154751.GD9275@mit.edu> <20090611171434.GA6011@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611171434.GA6011@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:14:36PM +0200, Frederic Weisbecker wrote:
> 
> For the filters, we could enter the text name which would be
> internally converted into a dev_t, there should be no problem.
> 
> Also the raw dev_t can be stored and then human-friendly printed on
> print time.
> 
> Both seem about trivial to add.

If someone wants to take this code and drop it into the core tracing
code, please feel free.

						- Ted

/* 
 * jbd2_dev_to_name is a utility function used by the jbd2 and ext4 
 * tracing infrastructure to map a dev_t to a device name.
 *
 * The caller should use rcu_read_lock() in order to make sure the
 * device name stays valid until its done with it.  We use
 * rcu_read_lock() as well to make sure we're safe in case the caller
 * gets sloppy, and because rcu_read_lock() is cheap and can be safely
 * nested.
 */
struct devname_cache {
	struct rcu_head	rcu;
	dev_t		device;
	char		devname[BDEVNAME_SIZE];
};
#define CACHE_SIZE_BITS 6
static struct devname_cache *devcache[1 << CACHE_SIZE_BITS];
static DEFINE_SPINLOCK(devname_cache_lock);

static void free_devcache(struct rcu_head *rcu)
{
	kfree(rcu);
}

const char *jbd2_dev_to_name(dev_t device)
{
	int	i = hash_32(device, CACHE_SIZE_BITS);
	char	*ret;
	struct block_device *bd;

	rcu_read_lock();
	if (devcache[i] && devcache[i]->device == device) {
		ret = devcache[i]->devname;
		rcu_read_unlock();
		return ret;
	}
	rcu_read_unlock();

	spin_lock(&devname_cache_lock);
	if (devcache[i]) {
		if (devcache[i]->device == device) {
			ret = devcache[i]->devname;
			spin_unlock(&devname_cache_lock);
			return ret;
		}
		call_rcu(&devcache[i]->rcu, free_devcache);
	}
	devcache[i] = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
	if (!devcache[i]) {
		spin_unlock(&devname_cache_lock);
		return "NODEV-ALLOCFAILURE"; /* Something non-NULL */
	}
	devcache[i]->device = device;
	bd = bdget(device);
	if (bd) {
		bdevname(bd, devcache[i]->devname);
		bdput(bd);
	} else
		__bdevname(device, devcache[i]->devname);
	ret = devcache[i]->devname;
	spin_unlock(&devname_cache_lock);
	return ret;
}
EXPORT_SYMBOL(jbd2_dev_to_name);
