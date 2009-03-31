Return-Path: <linux-kernel-owner+w=401wt.eu-S1764776AbZCaXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764776AbZCaXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764217AbZCaXW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:26 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:27278 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764212AbZCaXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:25 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXdY0udzuo=
X-RZG-CLASS-ID: mo05
Message-ID: <49D2A5AB.1090704@ursus.ath.cx>
Date: Wed, 01 Apr 2009 01:22:19 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alberto Gonzalez <info@gnebu.es>
CC: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es>
In-Reply-To: <200904010002.47077.info@gnebu.es>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.04.2009 00:02 Alberto Gonzalez wrote:
> In fact, thinking about it, this option would be the ideal one for desktops 
> and especially laptops (servers running databases are a different thing). What 
> we need is that _no_ application uses fsync. The decision as to when the data 
> should be written to disk should be left to the filesystem. And then the user 
> can choose how often they want this to happen (every 5, 15, 30, 60... 
> seconds). So if Ext4 could have a "nofsync" mount option that would disable 
> fsync from applications (i.e, it wouldn't honor an fsync call), that would be 
> wonderful. But then of course we have to make sure that if the kernel crashes 
> (or there's a power-off, etc..), we will just lose the new data that hasn't 
> been written to disk, but the old data will still be there. So maybe this 
> could be achieved with mounting the filesystem with nofsync, nodelalloc? 
>
>   
You are always thinking about the few seconds/minutes of work you gonna
lose, but there are different situations, too.

E.g. your POP3 client receives a very important mail, saves it to disk,
uses fsync to make sure it is out and tells the server to delete it. If
you are gonna delay the fsync, you will have a long window in which the
mail can get lost instead of a minimum window. Or are there any POP3
clients, which can synchronize the mail-polling with a spinning a disk?

There are tasks that are not very important, that should not spin up the
disk and there are tasks, that might better do so. It is the preference
of the user, which tasks should or should not spin up the disk, but the
application developer has to decide globally, whether or not to use
fsync() and the filesystem can't even distinguish the tasks at all,
except that it receives fsyncs or not.

So fine-tuning the system to the ideal disk-writing policy is really
problematic, especially given a lot of different people turning knobs:
- different filesystem developers using different methods and default
behaviors, which can be changed by distros and sys admins.
- different applications trying to use or not use fsync() and other
methods to get the best policies for any kind of fs. Or the developers
are incompetent enough to expect features from the filesystem which are
not always given, whether trained by ext3 data=ordered or trained by
reiserfs or just bare of any better fs knowledge.
- different users having different preferences on what data is how
important, but usually they can not change the fsync-policy of the
applications.

Andreas

