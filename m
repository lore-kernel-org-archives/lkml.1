Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZLAATs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZLAATs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZLAATq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:19:46 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:33825 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZLAATm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eplEXmOV+BFk4xYgJJTsNpflkm9sNZWgX14mkDcLzPmH215MM6xuzls+4JE6U6wQXu
         IB+Opx78mZdSlThmaKs57P+NA+hjMs7D72E6jOHdpZDw+5Ktbv+J+oH/00gBPRNzYWc+
         qky/Y8Q9c8RE2dufuyA34Qd2FOSZ0epV39KYM=
MIME-Version: 1.0
In-Reply-To: <1259328678.27675.539.camel@kiste>
References: <1259328678.27675.539.camel@kiste>
Date: Mon, 30 Nov 2009 16:12:07 -0800
X-Google-Sender-Auth: a25048a7c38aee73
Message-ID: <1f1b08da0911301612x619034ahfe4279e4ae8a9c3f@mail.gmail.com>
Subject: Re: Time nonlinearity (gettimeofday vs. mtime)
From: john stultz <johnstul@us.ibm.com>
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 5:31 AM, Matthias Urlichs <matthias@urlichs.de> wrote:
> Lately I've seen this ugliness:
>
> 13:39:06.000313 clock_gettime(CLOCK_REALTIME, {1259325546, 341196}) = 0 <0.000010>
> 13:39:06.000685 mkdir("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", 0777) = 0 <0.000043>
> 13:39:06.000973 stat64("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", {st_dev=makedev(252, 2), st_ino=1919104, st_mode=S_IFDIR|0755, st_nlink=2, st_uid=501, st_gid=501, st_blksize=4096, st_blocks=8, st_size=4096, st_atime=2009/11/27-13:39:05, st_mtime=2009/11/27-13:39:05, st_ctime=2009/11/27-13:39:05}) = 0 <0.000015>
>
> This strace says that st.st_mtime is smaller than time.tv_sec even though the time was acquired earlier.
> Apparently, the problem is that ext3 uses a cached time value for performance.
>
> Question: Is there a reason that the cached time is not updated every time somebody calls gettimeofday() or clock_gettime()?
> Or did just that nobody notice this problem yet?

This behavior is expected. For performance reasons (some clocksources
take 1.3us per read), most filesystem code uses current_kernel_time()
which provides the time at the last timer tick.

If you check mainline, there's a new CLOCK_REALTIME_COARSE clockid,
that provides the same behavior as the filesystem timestamps.

thanks
-john
