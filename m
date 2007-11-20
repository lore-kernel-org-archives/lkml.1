Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXKTPwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXKTPwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbXKTPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:52:22 -0500
Received: from sacred.ru ([62.205.161.221]:41045 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbXKTPwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:52:21 -0500
Message-ID: <4743026B.2020907@openvz.org>
Date: Tue, 20 Nov 2007 18:51:07 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
CC: kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
References: <20071119191000.GA1560@elf.ucw.cz> <200711192304.25087.rjw@sisk.pl>
In-Reply-To: <200711192304.25087.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 20 Nov 2007 18:51:09 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 19 of November 2007, Pavel Machek wrote:
>> Hi!
>>
>> I think that this worked before:
>>
>> root@amd:/proc# find . -name "timer_info"
>> find: WARNING: Hard link count is wrong for ./net: this may be a bug
>> in your filesystem driver.  Automatically turning on find's -noleaf
>> option.  Earlier results may have failed to include directories that
>> should have been searched.
>> root@amd:/proc#
> 
> I'm seeing that too.

I have a better things with 2.6.24-rc3 ;)

# cd /proc/net
# ls ..
ls: reading directory ..: Not a directory

and this

# cd /proc
# find
...
./net
find: . changed during execution of find
# find net
find: net changed during execution of find
# find net/
<this works ok however>

Moreover. Program that opens /proc/net and dumps the /proc/self/fd
files produces the following:

# cd /
# a.out /proc/net
...
lr-x------  1 root root 64 Nov 20 18:02 3 -> /proc/net/net (deleted)
...
# cd /proc/net
# a.out .
...
lr-x------  1 root root 64 Nov 20 18:03 3 -> /proc/net/net (deleted)
...
# a.out ..
...
lr-x------  1 root root 64 Nov 20 18:03 3 -> /proc/net
...

This all is somehow related to the shadow proc files.
E.g. the first problem (with -ENOTDIR) is due to the shadow /proc/net
dentry doesn't implement the .readdir method:

static const struct file_operations proc_net_dir_operations = {
        .read                   = generic_read_dir,
};

And I haven't managed to find out why the rest problems
occur...

Eric, do you have fixes for it?

> Rafael
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

