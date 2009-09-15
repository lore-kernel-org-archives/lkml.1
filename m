Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbZIOM7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbZIOM7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZIOM7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:59:02 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37070 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZIOM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Wy0J+vaDuz8nCL3apZ3Bjw98MnIHUX8+MfGP62hm4NJ+JebazwjIzqCm+jHQHL2eBS
         OnhisgZiD5c+HHwrHdYnK0ycK2csCs22y+WR4jfJWUyEh74MEV+9RYwaSYO5WWvxDIa2
         8ZwK5x+jDh10i9ZtfHsVwOgJrCzlPuR9wJJac=
MIME-Version: 1.0
Date: Tue, 15 Sep 2009 15:59:00 +0300
Message-ID: <2517f1930909150559p505b583fpf3501a1c7dad6634@mail.gmail.com>
Subject: Suggested addition to epoll interface - epoll_post_notification()
From: adi hodos <thefatredguy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone. Thank you for your time in reading this.
I have been playing with epoll lately and I would like to make a suggestion
regarding the epoll interface.
It would be nice to have a function to wake up a thread/process that is blocked
on an epoll_wait() call and sent it some
user defined data in the form of a struct epoll_event parameter ( something
similar with PostQueuedCompletionStatus() from Windows ).
My suggestion is for a function like this : int epoll_post_notification( int
epoll_descriptor , struct epoll_event* event );
It could be of much help in scenarios like these :

int e_accept;
int e_clients;

typedef enum {
 keycode_client_connection ,
 keycode_signal ,
 keycode_socketio ,
 keycode_fileio ,
 keycode_event ,
 keycode_timer
 ....
} event_key_type;

struct event_key {
  event_key_type keycode;
};

struct eventfd_wrapper {
 struct eventkey ek;
 int fd_event;
};

struct signalfd_wrapper {
 struct eventkey ek;
 int fd_signal;
};

struct client {
 struct event_key ek;
 int sock;
 ....
};

struct user_posted_event {
 struct event_key ek;
 union {
  void*    ptr_data;
  int      i_data;
  uint32_t u32;
  uint32_t u64;
 } u;
};


// thread A - waits for client connections using an epoll interface
for ( ; ; ) {
 epoll_wait( e_accept , ... );

 int s = accept();
 struct client* new_client = allocate_newclient();
 new_client->sock = s;
 struct user_posted_event* ue = allocate_newuserevent();
 ue->ek.keycode = keycode_client_connection;
 ue->u.ptr_data = new_client;

 struct epoll_event e;
 e.data.ptr = ue;
 epoll_post_notification( e_clients , &e );
}

// thread b - serves clients
for( ; ; ) {
 struct epoll_event[..] e;
 epoll_wait( e_clients , e , ... );

 struct event_key* key = ( struct event_key* )( e.data.ptr );
 if( key->keycode == keycode_client_connection ) {
   // handle new client connection
 } else if( key->keycode == keycode_signal ) {
   // handle signal
 } else if( .... ) {
  ...
 }

Again , thank you for your time in reviewing this.
