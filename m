Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZETJ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZETJ1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZETJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:27:09 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47337 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZETJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dY+LJfWyF+hwMDQ+SQ70zcvqElHSDAQ/Of1wXDZHR/IdNEomG3heIexX/i6Mat7GX3
         FAdWK7gaqvgZJP0QK20ZQ6VtFAAfkouvA9YK2X2z0GYAQOQ3or824p5lCz1LdCArhHoD
         rrJnNyWAd2/fivKsvhmKxvk1fyp7Bfj62UhSI=
Message-ID: <4A13CCE1.5000106@gmail.com>
Date: Wed, 20 May 2009 11:26:57 +0200
From: Marcin Krol <mrkafk@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: inotify limits - thousands (tens of thousands?) of watches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

First, apols for using up bandwidth, but I honestly found no other place 
where I can ask about this (and get meaningful reply).

I'm not a kernel programmer, but I want to develop a program that would 
watch modifications in *all* user directories on a busy server using 
inotify.

This is for high-availability purposes - events would be collected and 
once every several minutes changed dirs would be rsync'ed to failover 
server or smth like that would be done.

As inotify watches particular directory and not its subdirs, I would 
have to watch all directories.

This means I would have to create thousands or even tens of thousands of 
inotify watches.

So my questions are:

1. is it safe? that is, will it not lock the kernel up, or cause 
excessive memory consumption?

2. is it economic in terms of CPU time and RAM? I have no idea how to 
even measure such a thing happening in the kernel..




Here's first test take on inotify watch (runs on Debian):

######################### cut ################################

#include "stdio.h"
#include "stdlib.h"
#include "errno.h"
#include <linux/types.h>
#include <linux/inotify.h>
#include <sys/syscall.h>

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )


static inline int inotify_init (void)
{
         return syscall (__NR_inotify_init);
}

static inline int inotify_add_watch (int fd, const char *name, __u32 mask)
{
         return syscall (__NR_inotify_add_watch, fd, name, mask);
}

static inline int inotify_rm_watch (int fd, __u32 wd)
{
         return syscall (__NR_inotify_rm_watch, fd, wd);
}


int main( int argc, char **argv )
{
   int length, i = 0;
   int fd;
   int wd;
   char buffer[BUF_LEN];

   fd = inotify_init();

   if ( fd < 0 ) {
     perror( "inotify_init" );
   }

   wd = inotify_add_watch( fd, argv[1], IN_ALL_EVENTS );
   length = read( fd, buffer, BUF_LEN );

   if ( length < 0 ) {
     perror( "read" );
   }

   while ( i < length ) {
     struct inotify_event *event = ( struct inotify_event * ) &buffer[ i ];
     if ( event->len ) {
       if ( event->mask & IN_CREATE ) {
         if ( event->mask & IN_ISDIR ) {
           printf( "The directory %s was created.\n", event->name );
         }
         else {
           printf( "The file %s was created.\n", event->name );
         }
       }
       else if ( event->mask & IN_DELETE ) {
         if ( event->mask & IN_ISDIR ) {
           printf( "The directory %s was deleted.\n", event->name );
         }
         else {
           printf( "The file %s was deleted.\n", event->name );
         }
       }
       else if ( event->mask & IN_MODIFY ) {
         if ( event->mask & IN_ISDIR ) {
           printf( "The directory %s was modified.\n", event->name );
         }
         else {
           printf( "The file %s was modified.\n", event->name );
         }
       }
       else if ( event->mask & IN_ALL_EVENTS ) {
           printf("Some other event on %s, mask %x.\n", event->name, 
event->mask);
       }
     }
     i += EVENT_SIZE + event->len;
   }

   ( void ) inotify_rm_watch( fd, wd );
   ( void ) close( fd );

   exit( 0 );
}

######################### cut ################################

Regards,
mk
