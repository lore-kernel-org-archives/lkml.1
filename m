Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbZIDCeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbZIDCeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbZIDCe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:34:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:47061 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788AbZIDCe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:34:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183966078"
Date: Fri, 4 Sep 2009 10:34:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090904023421.GA11316@localhost>
References: <20090831140113.GA24005@localhost> <20090831140713.GA24185@localhost> <6afc6d4a0908310733l6426e21fu11d826f6ffa6a2af@mail.gmail.com> <20090901081458.GD1446@localhost> <6afc6d4a0909010710l2cf77fbbmb1ab192ed12a7efc@mail.gmail.com> <20090902030534.GC6248@localhost> <6afc6d4a0909020429l2bfecee9xd00527fcaa323751@mail.gmail.com> <20090902125057.GA7982@localhost> <6afc6d4a0909031346qda0b17coe4c60250fcac827f@mail.gmail.com> <20090904022123.GA11222@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090904022123.GA11222@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 10:21:23AM +0800, Wu Fengguang wrote:
> On Fri, Sep 04, 2009 at 04:46:14AM +0800, Fernando Silveira wrote:
> > On Wed, Sep 2, 2009 at 09:50, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > > On Wed, Sep 02, 2009 at 07:29:37PM +0800, Fernando Silveira wrote:
> > >> On Wed, Sep 2, 2009 at 00:05, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > >> > Is it tightly related to two interleaved write streams (the performance drop
> > >> > starts and stops with the second write stream)?  If so, it sounds like a SSD
> > >> > hardware/firmware problem.
> > >>
> > >> By write stream you mean more than one sdc file descriptor writing? I
> > >> don't usually do that, except for some tests (e.g. the "20090831_0908
> > >> iostat_x_1_5-80mbps_3" test). In that last test I did not do that.
> > >>
> > >> The performance drops even when the whole system is idle, with no
> > >> process other than the essential and my program that does nothing but
> > >> open("/dev/sdc", O_WRONLY) and loops in write(fd, buf, 4194304).
> > >
> > > Yes, I mean concurrently writing to two large files.
> > 
> > Sorry, but that cannot be happening in my tests. As I said before, the
> > only processes running are "init", "udevd", "sshd", "getty", "bash"
> > and "ddv". In the "dmesg" logs you can see that the only processes
> > that are writing to the disk are "ddv" and "pdflush". I just cannot
> > see another stream being written.
> > 
> > Please tell me if I'm missing something.
> 
> OK, so performance can go bad even for one single dd command?
> 
> > > Note that the
> > > low level disk write start/stop time is normally not equal to
> > > application(eg. dd) write start/stop time because of delayed write.
> > >
> > > Passing "oflag=direct" to dd can make the two times aligned.
> > 
> > I was aware of that, however I tried it and now the problem seems to
> > be much more difficult to be reproduced. I've being trying for a
> > couple of hours and so far all I could see was a small performance
> > drop from 80MB/s (now almost steady) to 60MB/s for some seconds
> > (approximately 16).
> > 
> > Could this possibly mean something else to you?
> 
> So performance is good on two concurrent O_DIRECT dd commands?
> 
> > > These commands can show the block IO internals and help confirm
> > > whether it's the kernel or hardware's fault:
> > >
> > >        blktrace -w1 /dev/sdc # do this while throughput is 25MB/s
> > >        blkparse sdc
> > 
> > I did that but I couldn't identify whose fault is. I don't understand
> > much about I/O internals (still trying to) and I wonder if you could
> > check it for me, please.
> > 
> > The new trace logs are in this tarball:
> > 
> > http://rootshell.be/~swrh/ssd-tests/log-20090903_1323-MK020903042C0001B-prosar_fcc2-bs_4M-0-blktrace_25mbps.tar.gz
> 
> The kernel seems to do its job fine. I do see one obvious pattern(*).
> The driver seems to complete IO requests _in batches_, which in turn
> make the kernel issue IO requests in batches. Which might choke the
> hardware/firmware in some subtle way.
> 
> In direct dd(s), the io queue is limited in size, so this kind of
> batching effect will not be obvious, which could explain why it
> performs better. 

Fernando, to confirm this, you can try running dd with lowered queue depth:

        echo 32 > /sys/block/sdc/queue/nr_requests

Thanks,
Fengguang

> ---
> 
> (*) `blkparse sdc` shows repeated patterns of
> 
> [thousands of A-Q-M sequences by ddv or pdflush]
>   8,32   0    11992     0.093682688  2417  A   W 210184323 + 1 <- (8,34) 194119323
>   8,32   0    11993     0.093682832  2417  Q   W 210184323 + 1 [ddv]
>   8,32   0    11994     0.093683066  2417  M   W 210184323 + 1 [ddv]
>   8,32   0    11995     0.093683552  2417  A   W 210184324 + 1 <- (8,34) 194119324
>   8,32   0    11996     0.093683702  2417  Q   W 210184324 + 1 [ddv]
>   8,32   0    11997     0.093683930  2417  M   W 210184324 + 1 [ddv]
>   8,32   0    11998     0.093684422  2417  A   W 210184325 + 1 <- (8,34) 194119325
>   8,32   0    11999     0.093684566  2417  Q   W 210184325 + 1 [ddv]
>   8,32   0    12000     0.093684799  2417  M   W 210184325 + 1 [ddv]
>   8,32   0    12001     0.093685285  2417  A   W 210184326 + 1 <- (8,34) 194119326
>   8,32   0    12002     0.093685429  2417  Q   W 210184326 + 1 [ddv]
>   8,32   0    12003     0.093685663  2417  M   W 210184326 + 1 [ddv]
>   8,32   0    12004     0.093686155  2417  A   W 210184327 + 1 <- (8,34) 194119327
>   8,32   0    12005     0.093686299  2417  Q   W 210184327 + 1 [ddv]
>   8,32   0    12006     0.093686533  2417  M   W 210184327 + 1 [ddv]
> [near 100 C-D sequences]
>   8,32   1    12378     0.094161760     0  C   W 210164352 + 128 [0]
>   8,32   1    12379     0.094318451     0  D   W 210164608 + 128 [swapper]
>   8,32   0    12007     0.095964571  2417  C   W 210164480 + 128 [0]
>   8,32   0    12008     0.096097816  2417  D   W 210164736 + 128 [ddv]
>   8,32   0    12009     0.097421849   211  C   W 210164608 + 128 [0]
>   8,32   0    12010     0.097566626   211  D   W 210164864 + 128 [kswapd0]
>   8,32   1    12380     0.099029562     0  C   W 210164736 + 128 [0]
>   8,32   1    12381     0.099199427     0  D   W 210164992 + 128 [swapper]
>   8,32   0    12011     0.101573454  2417  C   W 210164864 + 128 [0]
>   8,32   0    12012     0.101722292  2417  D   W 210165120 + 128 [ddv]
>   8,32   1    12382     0.103317406     0  C   W 210164992 + 128 [0]
>   8,32   1    12383     0.103491195     0  D   W 210165248 + 128 [swapper]
>   8,32   0    12013     0.104819283  2417  C   W 210165120 + 128 [0]
>   8,32   0    12014     0.104966411  2417  D   W 210165376 + 128 [ddv]
>   8,32   0    12015     0.106378658  2417  C   W 210165248 + 128 [0]
>   8,32   0    12016     0.106545098  2417  D   W 210165504 + 128 [ddv]
>   8,32   1    12384     0.108959520     0  C   W 210165376 + 128 [0]
>   8,32   1    12385     0.109088854     0  D   W 210165632 + 128 [swapper]
>   8,32   0    12017     0.110761352     0  C   W 210165504 + 128 [0]
>   8,32   0    12018     0.110881820     0  D   W 210165760 + 128 [swapper]
>   8,32   1    12386     0.112203050     0  C   W 210165632 + 128 [0]
>   8,32   1    12387     0.112310847     0  D   W 210165888 + 128 [swapper]
>   8,32   0    12019     0.113762264     0  C   W 210165760 + 128 [0]
>   8,32   0    12020     0.113868915     0  D   W 210166016 + 128 [swapper]
>   8,32   0    12021     0.116295958     0  C   W 210165888 + 128 [0]
>   8,32   0    12022     0.116405740     0  D   W 210166144 + 128 [swapper]
>   8,32   1    12388     0.118039279     0  C   W 210166016 + 128 [0]
>   8,32   1    12389     0.118146452     0  D   W 210166272 + 128 [swapper]
>   8,32   0    12023     0.119468271     0  C   W 210166144 + 128 [0]
>   8,32   0    12024     0.119569714     0  D   W 210166400 + 128 [swapper]
>   8,32   1    12390     0.120972296     0  C   W 210166272 + 128 [0]
>   8,32   1    12391     0.121081701     0  D   W 210166528 + 128 [swapper]
>   8,32   1    12392     0.123565552     0  C   W 210166400 + 128 [0]
>   8,32   1    12393     0.123674146     0  D   W 210166656 + 128 [swapper]
>   8,32   0    12025     0.125309227     0  C   W 210166528 + 128 [0]
>   8,32   0    12026     0.125417174     0  D   W 210166784 + 128 [swapper]
>   8,32   1    12394     0.126739754     0  C   W 210166656 + 128 [0]
>   8,32   1    12395     0.126845037     0  D   W 210166912 + 128 [swapper]
>   8,32   0    12027     0.128297684     0  C   W 210166784 + 128 [0]
>   8,32   0    12028     0.128407466     0  D   W 210167040 + 128 [swapper]
>   8,32   1    12396     0.130840911     0  C   W 210166912 + 128 [0]
>   8,32   1    12397     0.130947693     0  D   W 210167168 + 128 [swapper]
>   8,32   1    12398     0.132628003     0  C   W 210167040 + 128 [0]
>   8,32   1    12399     0.132732236     0  D   W 210167296 + 128 [swapper]
>   8,32   0    12029     0.134054889     0  C   W 210167168 + 128 [0]
>   8,32   0    12030     0.134160082     0  D   W 210167424 + 128 [swapper]
>   8,32   1    12400     0.135563066     0  C   W 210167296 + 128 [0]
>   8,32   1    12401     0.135664905     0  D   W 210167552 + 128 [swapper]
>   8,32   0    12031     0.138157000     0  C   W 210167424 + 128 [0]
>   8,32   0    12032     0.138263110     0  D   W 210167680 + 128 [swapper]
>   8,32   1    12402     0.139842121     0  C   W 210167552 + 128 [0]
>   8,32   1    12403     0.139945646     0  D   W 210167808 + 128 [swapper]
>   8,32   1    12404     0.141269145   210  C   W 210167680 + 128 [0]
>   8,32   1    12405     0.141377805   210  D   W 210167936 + 128 [pdflush]
>   8,32   0    12033     0.142830026     0  C   W 210167808 + 128 [0]
>   8,32   0    12034     0.142936449     0  D   W 210168064 + 128 [swapper]
>   8,32   1    12406     0.145314280     0  C   W 210167936 + 128 [0]
>   8,32   1    12407     0.145418662     0  D   W 210168192 + 128 [swapper]
>   8,32   0    12035     0.147057325     0  C   W 210168064 + 128 [0]
>   8,32   0    12036     0.147159590     0  D   W 210168320 + 128 [swapper]
>   8,32   1    12408     0.148482753     0  C   W 210168192 + 128 [0]
>   8,32   1    12409     0.148587813     0  D   W 210168448 + 128 [swapper]
>   8,32   1    12410     0.149991158     0  C   W 210168320 + 128 [0]
>   8,32   1    12411     0.150096956     0  D   W 210168576 + 128 [swapper]
>   8,32   0    12037     0.152584743     0  C   W 210168448 + 128 [0]
>   8,32   0    12038     0.152690919     0  D   W 210168704 + 128 [swapper]
>   8,32   1    12412     0.154328700     0  C   W 210168576 + 128 [0]
>   8,32   1    12413     0.154431589     0  D   W 210168832 + 128 [swapper]
>   8,32   0    12039     0.155754320     0  C   W 210168704 + 128 [0]
>   8,32   0    12040     0.155852734     0  D   W 210168960 + 128 [swapper]
>   8,32   1    12414     0.157305657     0  C   W 210168832 + 128 [0]
>   8,32   1    12415     0.157407880     0  D   W 210169088 + 128 [swapper]
>   8,32   1    12416     0.159789046     0  C   W 210168960 + 128 [0]
>   8,32   1    12417     0.159887321     0  D   W 210169216 + 128 [swapper]
>   8,32   0    12041     0.161590753     0  C   W 210169088 + 128 [0]
>   8,32   0    12042     0.161690654     0  D   W 210169344 + 128 [swapper]
>   8,32   1    12418     0.163013019     0  C   W 210169216 + 128 [0]
>   8,32   1    12419     0.163115584     0  D   W 210169472 + 128 [swapper]
>   8,32   0    12043     0.164519096     0  C   W 210169344 + 128 [0]
>   8,32   0    12044     0.164622195     0  D   W 210169600 + 128 [swapper]
>   8,32   1    12420     0.167173282     0  C   W 210169472 + 128 [0]
>   8,32   1    12421     0.167276254     0  D   W 210169728 + 128 [swapper]
>   8,32   1    12422     0.168925764     0  C   W 210169600 + 128 [0]
>   8,32   1    12423     0.169027981     0  D   W 210169856 + 128 [swapper]
>   8,32   0    12045     0.170351065     0  C   W 210169728 + 128 [0]
>   8,32   0    12046     0.170455910     0  D   W 210169984 + 128 [swapper]
>   8,32   1    12424     0.171907579     0  C   W 210169856 + 128 [0]
>   8,32   1    12425     0.172013444     0  D   W 210170112 + 128 [swapper]
>   8,32   0    12047     0.174390555     0  C   W 210169984 + 128 [0]
>   8,32   0    12048     0.174492477     0  D   W 210170240 + 128 [swapper]
>   8,32   1    12426     0.176133642     0  C   W 210170112 + 128 [0]
>   8,32   1    12427     0.176237095     0  D   W 210170368 + 128 [swapper]
>   8,32   1    12428     0.177558824     0  C   W 210170240 + 128 [0]
>   8,32   1    12429     0.177664029     0  D   W 210170496 + 128 [swapper]
>   8,32   0    12049     0.179067469     0  C   W 210170368 + 128 [0]
>   8,32   0    12050     0.179169668     0  D   W 210170624 + 128 [swapper]
>   8,32   1    12430     0.181612304     0  C   W 210170496 + 128 [0]
>   8,32   1    12431     0.181714443     0  D   W 210170752 + 128 [swapper]
>   8,32   0    12051     0.183355913     0  C   W 210170624 + 128 [0]
>   8,32   0    12052     0.183459354     0  D   W 210170880 + 128 [swapper]
>   8,32   1    12432     0.184783537     0  C   W 210170752 + 128 [0]
>   8,32   1    12433     0.184880864     0  D   W 210171008 + 128 [swapper]
>   8,32   0    12053     0.186333961     0  C   W 210170880 + 128 [0]
>   8,32   0    12054     0.186428577     0  D   W 210171136 + 128 [swapper]
>   8,32   0    12055     0.188818497     0  C   W 210171008 + 128 [0]
>   8,32   0    12056     0.188920809     0  D   W 210171264 + 128 [swapper]
>   8,32   1    12434     0.190562105     0  C   W 210171136 + 128 [0]
>   8,32   1    12435     0.190666416     0  D   W 210171392 + 128 [swapper]
>   8,32   0    12057     0.191988452     0  C   W 210171264 + 128 [0]
>   8,32   0    12058     0.192089505     0  D   W 210171520 + 128 [swapper]
>   8,32   1    12436     0.193493089     0  C   W 210171392 + 128 [0]
>   8,32   1    12437     0.193595240     0  D   W 210171648 + 128 [swapper]
>   8,32   1    12438     0.196087478     0  C   W 210171520 + 128 [0]
>   8,32   1    12439     0.196191783     0  D   W 210171776 + 128 [swapper]
>   8,32   0    12059     0.197831496     0  C   W 210171648 + 128 [0]
>   8,32   0    12060     0.197933803     0  D   W 210171904 + 128 [swapper]
>   8,32   1    12440     0.199257319     0  C   W 210171776 + 128 [0]
>   8,32   1    12441     0.199360568     0  D   W 210172032 + 128 [swapper]
>   8,32   0    12061     0.200814049     0  C   W 210171904 + 128 [0]
>   8,32   0    12062     0.200913626     0  D   W 210172160 + 128 [swapper]
>   8,32   1    12442     0.203309419     0  C   W 210172032 + 128 [0]
>   8,32   1    12443     0.203412830     0  D   W 210172288 + 128 [swapper]
>   8,32   0    12063     0.205060570     0  C   W 210172160 + 128 [0]
>   8,32   0    12064     0.205162907     0  D   W 210172416 + 128 [swapper]
>   8,32   0    12065     0.206486099     0  C   W 210172288 + 128 [0]
>   8,32   0    12066     0.206587944     0  D   W 210172544 + 128 [swapper]
>   8,32   1    12444     0.207990905     0  C   W 210172416 + 128 [0]
>   8,32   1    12445     0.208091646     0  D   W 210172672 + 128 [swapper]
>   8,32   0    12067     0.210583968     0  C   W 210172544 + 128 [0]
>   8,32   0    12068     0.210680377     0  D   W 210172800 + 128 [swapper]
>   8,32   1    12446     0.212327398     0  C   W 210172672 + 128 [0]
>   8,32   1    12447     0.212428457     0  D   W 210172928 + 128 [swapper]
>   8,32   0    12069     0.213751590     0  C   W 210172800 + 128 [0]
>   8,32   0    12070     0.213853765     0  D   W 210173056 + 128 [swapper]
>   8,32   0    12071     0.215305974     0  C   W 210172928 + 128 [0]
>   8,32   0    12072     0.215410602     0  D   W 210173184 + 128 [swapper]
>   8,32   1    12448     0.217849597     0  C   W 210173056 + 128 [0]
>   8,32   1    12449     0.217949042     0  D   W 210173312 + 128 [swapper]
>   8,32   0    12073     0.219601719     0  C   W 210173184 + 128 [0]
>   8,32   0    12074     0.219703342     0  D   W 210173440 + 128 [swapper]
>   8,32   1    12450     0.221025743     0  C   W 210173312 + 128 [0]
>   8,32   1    12451     0.221127756     0  D   W 210173568 + 128 [swapper]
>   8,32   0    12075     0.222580660     0  C   W 210173440 + 128 [0]
>   8,32   0    12076     0.222676374     0  D   W 210173696 + 128 [swapper]
>   8,32   0    12077     0.225014766     0  C   W 210173568 + 128 [0]
>   8,32   0    12078     0.225111955     0  D   W 210173824 + 128 [swapper]
>   8,32   1    12452     0.226711310     0  C   W 210173696 + 128 [0]
>   8,32   1    12453     0.226812111     0  D   W 210173952 + 128 [swapper]
>   8,32   0    12079     0.229019147     0  C   W 210173824 + 128 [0]
>   8,32   0    12080     0.229119366     0  D   W 210174080 + 128 [swapper]
>   8,32   1    12454     0.230581959     0  C   W 210173952 + 128 [0]
>   8,32   1    12455     0.230682370     0  D   W 210174208 + 128 [swapper]
>   8,32   0    12081     0.232003758     0  C   W 210174080 + 128 [0]
>   8,32   0    12082     0.232102141     0  D   W 210174336 + 128 [swapper]
>   8,32   0    12083     0.233503956     0  C   W 210174208 + 128 [0]
>   8,32   0    12084     0.233600131     0  D   W 210174464 + 128 [swapper]
>   8,32   1    12456     0.234921110     0  C   W 210174336 + 128 [0]
>   8,32   1    12457     0.235018282     0  D   W 210174592 + 128 [swapper]
>   8,32   0    12085     0.236420624     0  C   W 210174464 + 128 [0]
>   8,32   0    12086     0.236519661     0  D   W 210174720 + 128 [swapper]
>   8,32   1    12458     0.238714991     0  C   W 210174592 + 128 [0]
>   8,32   1    12459     0.238812841     0  D   W 210174848 + 128 [swapper]
>   8,32   0    12087     0.240419071     0  C   W 210174720 + 128 [0]
>   8,32   0    12088     0.240514299     0  D   W 210174976 + 128 [swapper]
