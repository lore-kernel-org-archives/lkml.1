Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXDISgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXDISgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXDISgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:36:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:28620 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXDISf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kALyIEFsC3wKfp62KyOUblFbgM+OjBO/RgGZf8Fx/LQ1s0fN0nuD2Ipcd4GfuwsZQG/m7U9HYAPvftmpIr5nqvOrEMpWC2YwDZAHnf7k1VbY/fybniTp+UR1SSCaxUWOOFy+N+016xdW8xrt0799N7MIOtmJLdWMozXJgCmNCfk=
Message-ID: <5c49b0ed0704091135o27a16a73wab13ae42136e8d21@mail.gmail.com>
Date: Mon, 9 Apr 2007 11:35:57 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Cc: johnrobertbanks@fastmail.fm,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Ignatich <ignatich@gmail.com>,
       reiserfs-list@namesys.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <m3zm5jebad.fsf@zoo.weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46157B5B.5000602@gmail.com> <461592FB.5060507@zytor.com>
	 <1175819681.20754.1183287946@webmail.messagingengine.com>
	 <461596DE.2020802@zytor.com>
	 <1175823288.25662.1183293506@webmail.messagingengine.com>
	 <4615C780.5040407@zytor.com>
	 <1175833931.8916.1183307802@webmail.messagingengine.com>
	 <20070407191715.GG3510@csclub.uwaterloo.ca>
	 <1175993097.32498.1183512070@webmail.messagingengine.com>
	 <m3zm5jebad.fsf@zoo.weinigel.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08 Apr 2007 06:32:26 +0200, Christer Weinigel <christer@weinigel.se> wrote:
> johnrobertbanks@fastmail.fm writes:
>
> > Lennart. Tell me again that these results from
> >
> > http://linuxhelp.150m.com/resources/fs-benchmarks.htm and
> > http://m.domaindlx.com/LinuxHelp/resources/fs-benchmarks.htm
> >
> > are not of interest to you. I still don't understand why you have your
> > head in the sand.
>
> Oh, for fucks sake, stop sounding like a broken record.  You have
> repeated the same totally meaningless statistics more times than I
> care to count.  Please shut the fuck up.

wow, it's really amazing how reiser4 can still inspire flamewars so
easily when Hans isn't even around to antagonize people and escalate
things

> As you discovered yourself (even though you seem to fail to understand
> the significance of your discovery), bonnie writes files that consist
> of mostly zeroes.  If your normal use cases consist of creating a
> bunch of files containing zeroes, reiser4 with compression will do
> great.  Just lovely.  Except that nobody sane would store a lot of
> files containing zeroes, except an an excercize in mental
> masturbation.  So the two bonnie benchmarks with lzo and gzip are
> totally meaningless for any real life usages.

yeah, i sure wish Grev was still around running the benchmarks and
regression testing, cause I thought she came up with a good, QA
oriented mix of real benchmarks.  aside from a number of streaming
video benchmarks i did, those were the only results i actually trusted
to compare reiser4 with other systems.  I know Ted doesn't like the
Mongo suite, cause it focuses on small files and shows the common
weakness of block-aligned storage ... personally i thought it was
great for its primary purpose, making sure reiser4 was optimized for
its target workload.  i also recall that the distribution of small
files to large ones in mongo was pulled from some paper out of CMU,
but i can't find the reference to that study right now.

> As for the amount of disk needed to store three kernel trees, the
> figures you quote show that Reiser4 does tail combining where the tail
> of multiple files are stored in one disk block.  A nice trick that
> seems save you about 15% disk space compared to ext3.  Now you have to
> realise what that means, it means that if the disk block containing
> those tails (or any metadata pointing at that block) gets corrupted,
> instead of just losing one disk block for one file, you will have lost
> the tail for all the files sharing that disk block.  Depending on your
> personal prioritites, saving 15% of the space may be worth the risk to
> you, or maybe not.  Personally, for the only disk I'm short on space
> on, I mostly store flac encoded images of my CD collection, and saving
> 2kByte out of every 300MByte disk simply doesn't make any difference,
> and I much prefer a stable file system that I can trust not to lose my
> data.  You might make different choices.

well, it turns out that reiser4 does things a little differently,
since tail packing has bad performance effects (i always turn it off
on my reiserfs partitions).  Reiser4 guarantees a file will be stored
contiguously if it is below a certain size (20K?), and instead stores
the whole file unaligned, so that many files can be packed together
without slack space.  this gives the best of both worlds
performance-wise, at the expense of some complicated flush code to
pack everything together in the tree before it gets written.  that
combined with the fine-grained locking scheme (per-node -- reiserfs
just has a global lock) is the primary reason the code is so
convoluted ... not poor coding.

> The same goes for just about every feature that you tout, it has its
> advantages, and it has its disadvantages.  Doing compression on data
> is great if the data you store is compressible, and sucks if it isn't.
> Doing compression on each disk block and then packing multiple
> compressed blocks into each physical disk block will probably save
> some space if the data is compressible, but at the same time it means
> that you will spend a lot of CPU (and cache footprint) compressing and
> uncompressing that data.  On a single user system where the CPU is
> mostly idle it might not make much of a difference, on a heavily
> loaded multiuser system it might do.

my understanding of the code is that it uses a heuristic to decide if
a file is already compressed, so that the system doesn't waste time on
them and simply writes them out directly.  there may also be a way to
turn it off for certain classes of files, this would be most useful
for executables and the like that are frequently mmap()ed and we care
more about page-alignment than read bandwidth or data density.
edward?

> Logs can be compressed quite well using a block based compression
> scheme, but the logs can be compressed even better by doing
> compression on the whole file with gzip.  So what's the best choice,
> to do transparent compression on the fly giving ok compression or
> teaching the userspace tools to do compression of old logs and get
> really good compression?  Or maybe disk space really isn't that
> important anyway and the best thing is to just leave the logs
> uncompressed.

i guess the idea with reiser4's compression (encryption and
compression, actually) is that you can get the feature for files you
care about without having to use *extra* CPU time, it only does the
work at flush time so that you can take advantage of cache effects for
files that see lots of modifications.  ATM i doubt this works well
though, cause you'd have to manually increase dirty_background_ratio
to keep things from continually flushing and using background CPU

NATE
