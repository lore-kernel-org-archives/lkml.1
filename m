Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXFEDf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXFEDf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbXFEDfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 23:35:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbXFEDfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 23:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=YLbI5s5FwKBj/+7v+uh2kdzueaQZ+I+0z9bc2JErrdI8xzkjxV7iCQL/MfRET7/bvxj70iIiuU9ENqXr484n/rUGSidWdAVSXfdkoyQtK+vTEuIzc7H7F61i78ednEZTNjNNlijv4hIKufSBESyI6KUGELgamQWeO/hANdXJw4E=
Message-ID: <4664D9E6.8000608@gmail.com>
Date: Tue, 05 Jun 2007 11:35:02 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu> <465FC7E7.7080804@gmail.com> <20070601192142.GA10039@elte.hu>
In-Reply-To: <20070601192142.GA10039@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Ingo Molnar wrote:
>> * Li Yu <raise.sail@gmail.com> wrote:
>>
>>   
>>> Also, I have want to know what's real meaning of
>>>
>>>    add_wait_runtime(rq, curr, delta_mine - delta_exec);
>>>
>>> in update_curr(), IMHO, it should be
>>>
>>>    add_wait_runtime(rq, curr, delta_mine - delta_fair);
>>>
>>> Is this just another heuristics? or my opinion is wrong again? :-)
>>>     
>>
>> well, ->wait_runtime is in real time units. If a task executes 
>> delta_exec time on the CPU, we deduct "-delta_exec" 1:1. But during that 
>> time the task also got entitled to a bit more CPU time, that is 
>> +delta_mine. The calculation above expresses this. I'm not sure what 
>> sense '-delta_fair' would make - "delta_fair" is the amount of time a 
>> nice-0 task would be entitled to - but this task might not be a nice-0 
>> task. Furthermore, even for a nice-0 task why deduct -delta_fair - it 
>> spent delta_exec on the CPU.
>> 
> 
> Eh, I wrong again~ I even took an experiment in last week end, this idea 
>>is really bad! ;(
> 
> I think the most inner of source of my wrong again and again is
> misunderstanding virtual time. For more better understanding this, I try 
> to write one python script to simulate CFS behavior. However, It can not 
> implement the fairness as I want. I really confuse here.
> 
> Would you like help me point out what's wrong in it? Any suggestion is 
> welcome. Thanks in advanced.
> 
> 
> 

I think use wait_runtime is more clear. so I modify this script.


#! /usr/bin/python

# htucfs.py - Hard-To-Understand-CFS.py ;)
# Wrote by Li Yu / 20070604

#
# only support static load / UP.
#


# Usage:
#	./htucfs.py nr_clock_ticks_to_run
#

import sys

class task_struct:
	def __init__(self, name, load_weight):
		self.name = name
		self.wait_runtime = 0
		self.fair_clock = 0
		self.load_weight = float(load_weight)
	def __repr__(self):
		return "%s/C%.2f" % (self.name, self.fair_clock)

idle_task = task_struct("idle", 0)

class run_queue:
	def __init__(self):
		self.raw_weighted_load = 0
		self.wall_clock = 0
		self.fair_clock = 0
		self.ready_queue = {}
		self.run_history = []
		self.task_list = []
		self.curr = None
		self.debug = 0
		
	def snapshot(self):
		if self.debug:
			print "%.2f" % self.fair_clock, self.ready_queue, self.curr

	def enqueue(self, task):
		if not self.ready_queue.get(task.wait_runtime):
			self.ready_queue[task.wait_runtime] = [task]
		else:
			# keep FIFO for same wait_runtime tasks.
			self.ready_queue[task.wait_runtime].append(task)
		self.raw_weighted_load += task.load_weight
		self.task_list.append(task)

	def dequeue(self, task):
		self.raw_weighted_load -= task.load_weight
		self.ready_queue[task.wait_runtime].remove(task)
		if not self.ready_queue[task.wait_runtime]:
			del self.ready_queue[task.wait_runtime]
		self.task_list.remove(task)
	
	def other_wait_runtime(self):
		task_list = self.task_list[:]
		for task in task_list:
			if task == self.curr:
				continue
			self.dequeue(task)
			task.wait_runtime += 1
			print task, "wait 1 sec"
			self.enqueue(task)
		
	def clock_tick(self):
		# clock_tick = 1.0
		self.fair_clock += 1.0/self.raw_weighted_load
		# delta_exec = 1.0
		delta_mine = self.curr.load_weight / self.raw_weighted_load
		self.dequeue(self.curr)
		self.other_wait_runtime()
		print self.curr, "run %.2f" % (delta_mine-1.0)
		self.curr.wait_runtime += (delta_mine-1.0)
		self.curr.fair_clock += 1.0/self.curr.load_weight
		self.enqueue(self.curr)
		self.pick_next_task()
	
	def pick_next_task(self):
		key_seq	= self.ready_queue.keys()
		if key_seq:
			key_seq.sort()
			self.curr = self.ready_queue[key_seq[-1]][0]
		else:
			self.curr = idle_task
		self.snapshot()
		self.record_run_history()

	def record_run_history(self):
		task = self.curr
		if not self.run_history:
			self.run_history.append([task, 1])
			return
		curr = self.run_history[-1]
		if curr[0] != task:
			self.run_history.append([task, 1])
		else:
			curr[1] += 1
	
	def show_history(self):
		stat = {}
		for entry in self.run_history:
			task = entry[0]
			nsec = entry[1]
			print "%s run %d sec" % (task, nsec)
			if task not in stat.keys():
				stat[task] = nsec
			else:
				stat[task] += nsec
		print "=============================="
		tasks = stat.keys()
		tasks.sort()
		for task in tasks:
			print task, "/", task.load_weight, ":", stat[task], "sec"
		print "=============================="

	def run(self, delta=0, debug=0):
		self.debug = debug
		until = self.wall_clock + delta
		print "-----------------------------"
		self.pick_next_task()
		while self.wall_clock < until:
			self.wall_clock += 1
			self.clock_tick()
		print "-----------------------------"

#
# To turn this, display verbose runtime information.
#
debug = True

if __name__ == "__main__":
	rq = run_queue()
	task1 = task_struct("TASK_1", 1)
	task2 = task_struct("TASK_2", 2)
	task3 = task_struct("TASK_3", 1)
	rq.enqueue(task1)
	rq.enqueue(task2)
	rq.enqueue(task3)
	rq.run(int(sys.argv[1]), debug)
	rq.show_history()

#EOF

Good luck

- Li Yu


