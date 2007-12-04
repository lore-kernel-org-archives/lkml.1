Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXLDVzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXLDVzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXLDVzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:55:25 -0500
Received: from waste.org ([66.93.16.53]:58302 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbXLDVzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:55:23 -0500
Date: Tue, 4 Dec 2007 15:54:04 -0600
From: Matt Mackall <mpm@selenic.com>
To: Mike McGrath <mmcgrath@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204215403.GF19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <4755BD0C.2060808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755BD0C.2060808@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:48:12PM -0600, Mike McGrath wrote:
> Alan Cox wrote:
> >>Here's the top 5:
> >>
> >>   266 28caf2c3-9766-4fe1-9e4c-d6b0ba8a0132
> >>   336 810e7126-1c69-4aff-b8b1-9db0fa8aa15a
> >>   402 c8dbb9d3-a9bd-4ba6-b92e-4a294ba5a95f
> >>   884 06e84493-e024-44b1-9b32-32d78af04039
> >>   931 e2b67e1d-e325-4740-b938-795addb45280
> >>
> >>The left number is times this month someone has submitted a profile with
> >>that UUID.  If we take the last one as an example has come from over 800
> >>IP's in the last 20 days.  It seems very unlikely that one person would
> >>find his way to 800 different IP's this month.  Let me know if you'd
> >>like more.
> >>    
> Background - Smolt runs this during its install:
> 
> /bin/cat /proc/sys/kernel/random/uuid > /etc/sysconfig/hw-uuid
> 
> For most users this would be run by the RPM %post scripts during install 
> from anaconda. For some reason there are some UUID's (like those listed 
> above) that come up more often then it seems they should if they are 
> truly random.

Ok, this sounds like it's run from install from CD or NFS, very early
in the boot process. Presumably it gets run during hands-free install
as well.

So a) we don't have a useful random seed file and b) we may have no
entropy. We should probably dredge up some more system data for the
initial pool seed (perhaps by passing in entropy from device probing).

The random seed file weakness is quite substantial. It affects
basically everything on RO media. We can probably implement a loop
something like the following to extract bits of entropy from the
system timing for those systems with no RW media:

int get_raw_timing_bit(void)
{
        int parity = 0;
        int start = clock();

        while(start == clock()) {
                parity ^= 1;
        }

        return parity;
}

int get_whitened_timing_bit(void) {
        int a, b;

        while (1) {
                a = get_raw_timing_bit();
                b = get_raw_timing_bit();
                if (a > b)
                        return 0;
                if (b > a)
                        return 1;
        }
}

int main(void)
{
        int i;

        for (i = 0; i < 64; i++)
                printf("%d", get_whitened_timing_bit());

        printf("\n");
}

That's gonna average about 4 clock edges per bit bits, so if the
external clock is running at 100HZ, we're looking at ~2.5 seconds for
64 bits of clock skew and scheduling "entropy".

The above can be done in userspace of course.

-- 
Mathematics is the supreme nostalgia of our time.
