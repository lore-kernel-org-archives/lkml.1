Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXLVT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXLVT0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXLVT0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:26:11 -0500
Received: from thunk.org ([69.25.196.29]:49885 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbXLVT0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:26:10 -0500
Date: Sat, 22 Dec 2007 14:25:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222192550.GD28891@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Christoph Lameter <clameter@sgi.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 10:01:37AM -0800, Linus Torvalds wrote:
> Well, I do have to admit that I'm not a huge fan of /proc/slabinfo, and 
> the fact that there hasn't been a lot of complaints about it going away 
> does seem to imply that it wasn't a very important ABI.
> 
> I'm the first to stand up for backwards compatibility, but I also try to 
> be realistic, and so far nobody has really complained about the fact that 
> /proc/slabinfo went away on any grounds but on the general principle of 
> "it was a user-visible ABI".

That's probably because the people who are most likely to be using
/proc/slabinfo tend to people people using kernels in production
environments, and they probably haven't started playing with SLUB yet.
So the fact we haven't heard the yelling doesn't necessarily mean that
people won't notice.

I know of a number of debugging scripts that periodically poll
/proc/slabinfo to find out what is using memory and to track trends
and predict potential problems with memory usage and balance.  Indeed,
I've left several such scripts behind at various customer
installations after debugging memory usage problems, and some system
administrators very much like being able to collect that information
easily.  So I can say for sure there at there are scripts out there
that depend on /proc/slabinfo, but they generally tend to be at sites
where people won't be running bleeding edge kernels.

> That said, I'm not a *huge* fan of /sys/slab/ either. I can get the info I 
> as a developer tend to want from there, but it's really rather less 
> convenient than I'd like. It is really quite hard, for example, to get any 
> kind of "who actually uses the most *memory*" information out of there. 

I have a general problem with things in /sys/slab, and that's just
because they are *ugly*.  So yes, you can write ugly shell scripts
like this to get out information:

> You have to use something like this:
> 
> 	for i in *
> 	do
> 		order=$(cat "$i/order")
> 		slabs=$(cat "$i/slabs")
> 		object_size=$(cat "$i/object_size")
> 		objects=$(cat "$i/objects")
> 		truesize=$(( $slabs<<($order+12) ))
> 		size=$(( $object_size*$objects ))
> 		percent=$(( $truesize/100 ))
> 		if [ $percent -gt 0 ]; then
> 			percent=$(( $size / $percent ))
> 		fi
> 		mb=$(( $size >> 10 ))
> 		printf "%10d MB %3d %s\n" $mb $percent $i
> 	done | sort -n | tail

But sometimes when trying to eyeball what is going on, it's a lot
nicer just to use "cat /proc/slabinfo".  

Another problem with using /sys/slab is that it is downright *ugly*.
Why is it for example, that /sys/slab/dentry is a symlink to
../slab/:a-0000160?  Because of this, Linus's script reports dentry twice:

     10942 MB  86 buffer_head
     10942 MB  86 journal_head
     10943 MB  86 :a-0000056
     21923 MB  86 dentry
     21924 MB  86 :a-0000160
     78437 MB  94 ext3_inode_cache

Once as "dentry" and once as ":a-0000160".  A similar situation
happens with journal_head and ":a-0000056".  I'm sure this could be
filtered out with the right shell or perl script, but now we're
getting even farther from /proc/slabinfo.  

Further, if you look at Documentation/sysfs-rules.txt (does anyone
ever read it or bother to update it?), /sys/slab isn't documented so
it falls in the category of "everything else is a kernel-level
implementation detail which is not guaranteed to be stable".  Nice....

Also, looking at sysfs-rules.txt, it talks an awful lot about reading
symlinks, and implying that actually trying to *dereference* the
symlinks might not actually work.  So I'm pretty sure linus's "cd
/sys/slab; for i in *" violates the Documentation/sysfs-rules.txt
guidelines even if /sys/slab were documented.

In general, /sys has some real issues that need some careful scrutiny.
Documentation/sysfs-rules.txt is *not* enough.  For example, various
official websites are telling people that the way to enable or disable
power-saving is:

	echo 5 > /sys/bus/pci/drivers/iwl4965/*/power_level

(Reference: http://www.lesswatts.org/tips/wireless.php)

Aside from the fact that "iwconfig wlan0 power on" is easier to type
and simpler to undrestand, I'm pretty sure that the above violates
sysfs-rules.txt.  From looking at sysfs-rules.txt, the fact that you
have to read symlinks as the only valid and guaranteed way for things
to work means that you have to write a perl script to safely
manipulate things in /sys.  People are ignoring sysfs-rules.txt, and
giving advice in websites contrary to sysfs-rules.txt because it's too
hard to follow.

> I worry about the lack of atomicity in getting the statistics.

And that's another problem with trying to use /sys when trying to get
statistics in bulk...  Very often the tables in /proc/* were not only
more convenient, but allowed for atomic access.

						- Ted
