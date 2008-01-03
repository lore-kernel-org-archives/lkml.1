Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYACJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYACJxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYACJxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:53:00 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:33094 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754494AbYACJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:53:00 -0500
Message-ID: <477CB075.5080507@nigel.suspend2.net>
Date: Thu, 03 Jan 2008 20:52:53 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200801022304.19279.rjw@sisk.pl> <477CA8A8.2090201@nigel.suspend2.net> <200801031047.58559.oliver@neukum.org>
In-Reply-To: <200801031047.58559.oliver@neukum.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Oliver Neukum wrote:
> Am Donnerstag 03 Januar 2008 schrieb Nigel Cunningham:
>> On top of this, I made a (too simple at the moment) freeze_filesystems
>> function which iterates through &super_blocks in reverse order, freezing
>> fuse filesystems or ordinary ones. I say 'too simple' because it doesn't
>> currently allow for the possibility of someone mounting (say) ext3 on
>> fuse, but that would just be an extension of what's already done.
> 
> How do you deal with fuse server tasks using other fuse filesystems?

Since they're frozen in reverse order, the dependant one would be frozen
first.

> How does freeze_filesystems() look?

Removing my ugly debugging statements, it's currently:

/**
 * freeze_filesystems - lock all filesystems and force them into a
consistent
 * state
 */
void freeze_filesystems(int which)
{
        struct super_block *sb;

        lockdep_off();

        /*
         * Freeze in reverse order so filesystems dependant upon others are
         * frozen in the right order (eg. loopback on ext3).
         */
        list_for_each_entry_reverse(sb, &super_blocks, s_list) {
                if (sb->s_type->fs_flags & FS_IS_FUSE &&
                    sb->s_frozen == SB_UNFROZEN &&
                    which & FS_FREEZER_FUSE) {
                        sb->s_frozen = SB_FREEZE_TRANS;
                        sb->s_flags |= MS_FROZEN;
                        continue;
                }

                if (!sb->s_root || !sb->s_bdev ||
                    (sb->s_frozen == SB_FREEZE_TRANS) ||
                    (sb->s_flags & MS_RDONLY) ||
                    (sb->s_flags & MS_FROZEN) ||
                    !(which & FS_FREEZER_NORMAL))
                        continue;
                freeze_bdev(sb->s_bdev);
                sb->s_flags |= MS_FROZEN;
        }

        lockdep_on();
}

Nigel
