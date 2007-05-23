Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbXEWPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbXEWPJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbXEWPIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:08:55 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58312 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299AbXEWPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:08:54 -0400
Date: Wed, 23 May 2007 19:07:32 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070523150732.GA2456@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org> <20070517160308.GA26643@2ka.mipt.ru> <20070517171017.GB15676@lazybastard.org> <20070520173049.GA20907@2ka.mipt.ru> <20070523125840.GC24738@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070523125840.GC24738@lazybastard.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 23 May 2007 19:07:43 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:58:41PM +0200, Jörn Engel (joern@lazybastard.org) wrote:
> On Sun, 20 May 2007 21:30:52 +0400, Evgeniy Polyakov wrote:
> > 
> > In that case segment size must be more than 32 bits, or below
> > transformation will not be correct?
> 
> Must it?  If segment size is just 20bit then the filesystem may only be
> 52bit.  Or 51bit when using signed values.

And what if it is 33 bits? Or it is not allowed?

> > segsize is long, but should be u64 I think.
> 
> It could be s32 as well.

It is a matter of definition - if segment size is allowed to be more
than 32 bits, then below transformation is not correct, otherwise
segment size should not use additional 32bits on 64bit platform, since
it is long.

> > static void fixup_from_wbuf(struct super_block *sb, struct logfs_area
> > 	*area, void *read, u64 ofs, size_t readlen)
> > 
> > u32 read_start = ofs & (super->s_segsize - 1);
> > u32 read_end = read_start + readlen;
> > 
> > And this can overflow, since readlen is size_t.
> 
> Theoretically yes.  Practically readlen is bounded to sb->blocksize plus
> one header.  I'll start worrying about that when blocksize approaches
> 32bit limit.
> 
> > > If anyone can find similar bugs, the bounty is a beer or non-alcoholic
> > > beverage of choice. :)
> > 
> > Stop kiling your kidneys, your health and promote such antisocial style
> > of life, start drinking vodka instead.
> 
> I'm just a German.  Forgive me if I drink lesser beverages.

You should definitely change that.


Btw, what about this piece:

int logfs_erase_segment(struct super_block *sb, u32 index)
{
	struct logfs_super *super = LOGFS_SUPER(sb);

	super->s_gec++;

	return mtderase(sb, index << super->s_segshift, super->s_segsize);
}

index << super->s_segshift might overflow, mtderase expects loff_t
there, since index can be arbitrary segment number, is it possible, that
overflow really occurs?

> Jörn
> 
> -- 
> Eighty percent of success is showing up.
> -- Woody Allen

-- 
	Evgeniy Polyakov
