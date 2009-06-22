Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZFVU7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZFVU7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZFVU6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:58:54 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:40470 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZFVU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:58:54 -0400
Subject: Re: [PATCH 1/1] hwlat_detector: A system hardware latency detector
From: Jon Masters <jonathan@jonmasters.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090622121736.588ae743.akpm@linux-foundation.org>
References: <20090611045829.714510042@jonmasters.org>
	 <20090611045939.103213179@jonmasters.org>
	 <20090622121736.588ae743.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Mon, 22 Jun 2009 16:58:03 -0400
Message-Id: <1245704283.15044.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

Thanks for the feedback. It's appreciated, as always.

On Mon, 2009-06-22 at 12:17 -0700, Andrew Morton wrote:
> On Thu, 11 Jun 2009 00:58:30 -0400
> Jon Masters <jonathan@jonmasters.org> wrote:

> > +	  into an 8K samples global ring buffer until retreived.
> 
> "i before e except after c"!

Good point! All that American miss-spelling of English words has finally
driven me to this, and now there can surely be little hope left for me.

> > +#define BUF_SIZE_DEFAULT	262144UL		/* 8K*(sizeof(entry)) */
> 
> I still don't understand this.

Steven's ring_buffer stores whatever "object" you want it to, and in
this case I store sample structs in there, which makes it correct. I
guess I'm happy to change the allocation, I'm just doing it the way
other users do in-kernel already (I won't get started on the number of
places where the ring_buffer could be used but is re-invented again) ;)

> Later, we do this:
> 
> > +static unsigned long buf_size = BUF_SIZE_DEFAULT;
> 
> But there is no provision for altering `buf_size', so we might as well
> have just used the constant directly.

I intend to add that - seems reasonable to design with that in mind.
Steven's ring_buffer code supports resizing, so I stuck that in. I don't
happen to handle CPU hotplug very well either (shouldn't crash though,
just might lose readings) but then, if you're trying to benchmark and
you hotadd/remove a CPU while you're doing it...that's quite insane.

> We seem to be forward-declaring functions which didn't need forward
> declarations.  This adds duplication and noise - personally I think
> it's better to just get the functions in the correct order and only use
> forward-decls where circularities are present.
> 
> A couple of struct are needlessly forward-decalred too.  etc.

Well, call me pedantic but I was always taught to do it this way for
completeness. If that's not how we want to do it in-kernel, I'm happy
but I'd like to know where this is spelled out (if it is) so I can go
add that to my to-read list and get this sorted out in my head. And
conversely, if it's not documented then I should also be fixing it.

> > +	char buf[U64STR_SIZE];
> > +	int csize = min(cnt, sizeof(buf));
> > +	u64 val = 0;
> > +	int err = 0;
> > +
> > +	memset(buf, '\0', sizeof(buf));
> 
> This is unneeded.

I disagree. I always like to explicitly initialize everything to known
values, even if it might be done for me. In this case, I want to ensure
there is no way the copy_from_user will give me a non-terminated buffer
(I add an explicit NULL later too) and that it is zeroed before use. If
this were some hot-path that mattered, it would be different, but it's a
trivial function that's already dealing with a copy_from_user. I'm not
fussy about changing, but just so you understand my pedantic logic.

> > +	if (copy_from_user(buf, ubuf, csize))
> > +		return -EFAULT;
> > +
> > +	buf[U64STR_SIZE-1] = '\0';			/* just in case */
> > +	err = strict_strtoull(buf, 10, &val);
> > +	if (err)
> > +		return -EINVAL;
> 
> Again, all the above looks terribly generic.  Isn't there already a
> helper function for this?  If not, there should be one.  (I should
> know, but I'm asleep).

Nope. There is to go the other way, but not this way (I did look). I
guess I could write one - I was trying to keep this fairly self
contained to get it in upstream sooner (so people will stop whining
about "Linux sucking" on systems with huge SMI braindeadness, and self
contained selfishly because I have a vendor kernel backport here too)
but I'm happy to look for where to add generic helpers in the next
iteration. I should really work on being more helpful like that.

> > +	buf[0] = enabled ? '1' : '0';
> > +	buf[1] = '\n';
> > +	buf[2] = '\0';
> > +	if (copy_to_user(ubuf, buf, strlen(buf)))
> 
> "3" :)

I dislike hard-coding constants of any kind. Again, it's a style thing
and I guess we might just have different approaches, from your previous
comments on my style choices. I can change to suit the norm... ;)

> > +	if (val) {
> > +		if (enabled)
> > +			goto unlock;
> > +		enabled = 1;
> > +		__reset_stats();
> > +		if (start_kthread())
> > +			return -EFAULT;
> 
> -EFAULT seems inappropriate.

If you're unable to kick off the kernel thread, what should you return?
I thought of ENOMEM or something (because it's normally the case that we
couldn't make the kthread due to that), but that doesn't feel right
either because there are other ways in which we might be failing.

> (I have a feeling I've mentioned several of these things before?)

Nah, I listened and fixed those.

> > +static int init_debugfs(void)
> > +{
> > +	int ret = -ENOMEM;
> > +
> > +	debug_dir = debugfs_create_dir(DRVNAME, NULL);
> > +	if (!debug_dir)
> > +		goto err_debug_dir;
> 
> The debugfs functions should return an errno, not a NULL on error. 
> Thwap whoever did that.

Well, at least they do internal locking of a fashion on debugfs created
simple file entries (that is mostly useless in many cases) - how many
people in-kernel are using these incorrectly I have no idea (yet). I
wind up being really pedantic and making sure I'm locking everything
explicitly for myself to ensure there's no debugfs races later.

> > +	ret = init_stats();
> > +	if (0 != ret)
> 
> Didn't I already whine about the dyslexic comparisons?

Argh. You did, and I tried to listen. Just like I'm going to try to
listen about not explicitly nullifying things, forward declaring, or
other things I really seem to enjoy doing ;)

So...I'll post another update (thanks again). Am I certainly too late
for this merge window? That's ok too.

Jon.


