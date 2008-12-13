Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbYLMIFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbYLMIFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYLMIFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:05:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:18127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYLMIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AYIVnETNmMSXy+7vT30puTSj2Tg+5U80ULoPJnB8PeuFDQWtQTwJNC2KoLQ/XE98pm
         FW+sFHYJbS9XouB0pSFMzvKB75NnFLaicA0BO+13VMna3ASR8q2/EZGGLhgAqwH8xIUE
         8Yt0SNlp8Dj/gZzB1pOkArJYf2QwGfgr5jBP0=
Subject: Re: [PATCH] Fix genius pensketch 12x9 tablet
From: Matt Helsley <matt.helsley@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081213075342.GA11346@kroah.com>
References: <1229150548.11171.6.camel@molly>
	 <20081213075342.GA11346@kroah.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 00:05:30 -0800
Message-Id: <1229155530.13862.9.camel@molly>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 23:53 -0800, Greg KH wrote:
> On Fri, Dec 12, 2008 at 10:42:28PM -0800, Matt Helsley wrote:
> > The Genius PenSketch 12x9 tablet has a puck (labeled a
> > "Tablet Mouse") in addition to a pen. Without registering a quirk
> > the tablet appears to be a single input device that reports the
> > wrong axis information in /proc/bus/input/devices, and sends
> > incorrect events (e.g. ABS_Z instead of ABS_Y). This information
> > confuses the X evdev driver and makes the device impossible to
> > use.
> > 
> > The quirk fixes events and splits the device into multiple input
> > event devices so that at least the puck is useful.
> > 
> > Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
> > ---
> > NOTE: xinput lists the puck but not the pen. I've been using a
> > python script to verify the contents of the events independently
> > of X and, as far as I can tell, the remaining problems are in X
> > itself.
> 
> I have a tablet here that I'm having troubles getting to work.  Any
> chance I could get a copy of your python script so I can try to debug
> what is going wrong, and if it's a X problem or a kernel issue like you
> found for your device?
> 
> thanks,
> 
> greg k-h

Sure. Sometime around 2.6.24 I updated this script (originally by Micah
Dowty) to include more evdev #defines, work on 64-bit systems, and
decode some bitvectors into their C symbols.

Cheers,
	-Matt Helsley

#!/usr/bin/env python
""" evdev.py

This is a Python interface to the Linux input system's event device.
Events can be read from an open event file and decoded into spiffy
python objects. The Event objects can optionally be fed into a Device
object that represents the complete state of the device being monitored.

Copyright (C) 2003-2004 Micah Dowty <micah@navi.cx>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

From:  http://svn.navi.cx/misc/trunk/python/evdev/
"""

import struct, sys, os, time, errno
from fcntl import ioctl
import binascii
import array

__all__ = ["Event", "Device"]

def hexbytes(s):
	return str(len(s)) + ': ' + binascii.hexlify(s)

def demo():
	"""Open the event device named on the command line, use incoming
	   events to update a device, and show the state of this device.
	   """
	dev = Device(sys.argv[1])
	print dev
	while 1:
		dev.poll()
		#time.sleep(0.1)

class bitmap:
	def __init__(self, bits = None):
		if bits is None:
			self.bits = array.array('c')
		else:
			self.bits = array.array('c', bits)
	def set_bits(self, from_str):
		self.bits.fromstring(from_str)
	def test_bit(self, bit_num):
		return ord(self.bits[(bit_num >> 3)]) & (1 << (bit_num & 7))
	def num_bits(self):
		return len(self.bits)*8
	def num_bytes(self):
		return len(self.bits)
	def is_empty(self):
		return (self.num_bytes == 0)
	def clear_bit(self, bit_num):
		byte = self.bits[(bit_num >> 3)]
		byte = byte & ~(1 << (bit_num & 7))
		self.bits[(bit_num >> 3)] = byte
	def set_bit(self, bit_num):
		byte = self.bits[(bit_num >> 3)]
		byte = byte | (1 << (bit_num & 7))
		self.bits[(bit_num >> 3)] = byte
	def hex(self):
		return binascii.hexlify(self.bits.tostring())
	def expand(self, names, delim = ','):
		name_list = []
		for i in range(0, self.num_bits()):
			if self.test_bit(i):
				if callable(names):
					name = names(i)
				else:
					try:
						name = names.fromNumber(i)
					except:
						name = names[i]
				if not isinstance(name, basestring):
					name = str(name)
				name_list.append(name)
		return delim.join(name_list)

class BaseDevice:
	"""Base class representing the state of an input device, with axes and buttons.
	   Event instances can be fed into the Device to update its state.
	   """
	def __init__(self):
		self.axes = {}
		self.absAxisInfo = {}
		self.buttons = {}
		self.name = None

	def update(self, event):
		f = getattr(self, "update_%s" % event.type, None)
		if f:
			f(event)

	def __repr__(self):
		items = [ str(i) for i in self.__dict__.items() ]
		return str('\n'.join(items))
	def update_EV_KEY(self, event):
		self.buttons[event.code] = event.value

	def update_EV_ABS(self, event):
		self.axes[event.code] = event.value

	def update_EV_REL(self, event):
		self.axes[event.code] = self.axes.get(event.code, 0) + event.value

	def __getitem__(self, name):
		"""Retrieve the current value of an axis or button,
		   or zero if no data has been received for it yet.
		   """
		if name in self.axes:
			return self.axes[name]
		else:
			return self.buttons.get(name, 0)

# asm-generic/ioctl.h
IOC_NRBITS = 8L
IOC_TYPEBITS = 8L
IOC_SIZEBITS = 14L
IOC_DIRBITS = 2L

IOC_NRMASK = ((1L << IOC_NRBITS)-1L)
IOC_TYPEMASK = ((1L << IOC_TYPEBITS)-1L)
IOC_SIZEMASK = ((1L << IOC_SIZEBITS)-1L)
IOC_DIRMASK = ((1L << IOC_DIRBITS)-1L)

IOC_NRSHIFT = 0L
IOC_TYPESHIFT = IOC_NRSHIFT+IOC_NRBITS
IOC_SIZESHIFT = IOC_TYPESHIFT+IOC_TYPEBITS
IOC_DIRSHIFT = IOC_SIZESHIFT+IOC_SIZEBITS

IOC_NONE = 0L
IOC_WRITE = 1L
IOC_READ = 2L

def IOC(dir, type, nr, size):
	return (dir<<IOC_DIRSHIFT)|(size<<IOC_SIZESHIFT)|(type<<IOC_TYPESHIFT)|(nr<<IOC_NRSHIFT)

def IO(type, nr):
	return IOC(IOC_NONE,type,nr,0)
def IOR(type, nr, size):
	return IOC(IOC_READ,type,nr,size)
def IOW(type, nr, size):
	return IOC(IOC_WRITE,type,nr,size)
def IOWR(type, nr, size):
	return IOC(IOC_READ|IOC_WRITE,type,nr,size)
def IOC_DIR(nr):
	return (((nr) >> IOC_DIRSHIFT) & IOC_DIRMASK)
def IOC_TYPE(nr):
	return (((nr) >> IOC_TYPESHIFT) & IOC_TYPEMASK)
def IOC_NR(nr):
	return (((nr) >> IOC_NRSHIFT) & IOC_NRMASK)
def IOC_SIZE(nr):
	return (((nr) >> IOC_SIZESHIFT) & IOC_SIZEMASK)

## end of ioctl defs

# python struct format defs and their sizes
int_format = "i"
int_size = struct.calcsize(int_format)
int_array2_format = "2i"
int_array2_size = struct.calcsize(int_array2_format)
input_id_format = "4H" # u16
input_id_size = struct.calcsize(input_id_format)
input_absinfo_format = "5i" # s32
input_absinfo_size = struct.calcsize(input_absinfo_format)
ff_effect_format = "HhH HH HH  HHHHH HHHH IH" # space denotes nested struct
ff_effect_size = struct.calcsize(ff_effect_format)

## begin input.h IOCTL defs
# evdev ioctl constants and EVIOC functions. ASCII 'E' == 0x45
EVIOCGVERSION = IOR(0x45, 0x01, int_size)		  # get driver version
EVIOCGID = IOR(0x45, 0x02, input_id_size)		  # get device struct input_id
EVIOCGREP = IOR(0x45, 0x03, int_array2_size) # get repeat settings
EVIOCSREP = IOW(0x45, 0x03, int_array2_size) # set repeat settings
EVIOCGKEYCODE = IOR(0x45, 0x04, int_array2_size) # get keycode
EVIOCSKEYCODE = IOW(0x45, 0x04, int_array2_size) # set keycode

# these are functions and not merely values because the ioctl number
# incorporates more than a simple command (usually length of a buffer)
# note that buffers can only be of a length representable by 14 bits
# (see /usr/include/asm-generic/ioctl.h)
def EVIOCGNAME(length):
	return IOC(IOC_READ, 0x45, 0x06, length)
def EVIOCGPHYS(length):
	return IOC(IOC_READ, 0x45, 0x07, length)
def EVIOCGUNIQ(length):
	return IOC(IOC_READ, 0x45, 0x08, length)

def EVIOCGKEY(length):
	return IOC(IOC_READ, 0x45, 0x18, length)
def EVIOCGLED(length):
	return IOC(IOC_READ, 0x45, 0x19, length)
def EVIOCGSND(length):
	return IOC(IOC_READ, 0x45, 0x1a, length)
def EVIOCGSW(length):
	return IOC(IOC_READ, 0x45, 0x1b, length)

def EVIOCGBIT(ev, length): # get event bits
	return IOC(IOC_READ, 0x45, 0x20 + ev, length)
def EVIOCGABS(abs): # get abs value/limits
	return IOR(0x45, 0x40 + abs, input_absinfo_size)
def EVIOCSABS(abs): # set abs value/limits
	return IOW(0x45, 0x40 + abs, input_absinfo_size)

EVIOCSFF = IOC(IOC_WRITE, 0x45, 0x80, ff_effect_size)
EVIOCRMFF = IOW(0x45, 0x81, int_size)
EVIOCGEFFECTS = IOR(0x45, 0x84, int_size)
EVIOCGRAB = IOW(0x45, 0x90, int_size)

def NBYTES(highest_bit):
	return ((highest_bit - 1)/8) + 1

class Device(BaseDevice):
	"""An abstract input device attached to a Linux evdev device node"""
	def ioctl(self, op, buffer):
		return ioctl(self.fd, op, buffer)
	# ioctl convenience functions: get/set string, int, int[2], int[n]

	# Get a string up to length characters. Note that length is also
	# encoded in op. Trims unused space after the nul byte.
	def ioctl_get_string(self, op, length):
		buffer = "\0"*length
		buffer = self.ioctl(op, buffer)
		return buffer[:buffer.find("\0")]
	# Get an automatically sized string. Needs the operation given as
	# a function of string length -- not a constant string length!
	# Can be slow because we guess how long the name is and repeat
	# if our guess was not large enough.
	def ioctl_get_astring(self, opfn, initial_guessed_len=1):
			length = initial_guessed_len
#			print repr(opfn)
			while True:
				buffer = self.ioctl_get_string(opfn(length), length)
				if (len(buffer)+1) < length:
					break
				length = length*2
#			print "done! length: %d string: %s" % (length, buffer)
			return buffer
	# Get length bytes. Note that length is also encoded in op.
	def ioctl_get_bytes(self, op, length):
		buffer = "\0"*length
		return self.ioctl(op, buffer)
	def ioctl_get_bitmap(self, op, length):
		buffer = '\0'*length
		buffer = self.ioctl(op, buffer)
		return bitmap(bits=buffer)
	# Get an int
	def ioctl_get_int(self, op):
		buffer = "\0"*int_size
		return struct.unpack(int_format, ioctl(self.fd, op, buffer))
	# Get two ints
	def ioctl_get_int2(self, op):
		buffer = "\0"*int_array2_size
		return struct.unpack(int_array2_format, ioctl(self.fd, op, buffer))
	# Get an array of num_ints ints
	def ioctl_get_int_array(self, op, num_ints):
		format = "i"*num_ints
		buffer = "\0"*struct.calcsize(format)
		return struct.unpack(format, ioctl(self.fd, op, buffer))
	# Set a string -- length is encoded in op
	def ioctl_set_string(self, op, buffer):
		self.ioctl(op, buffer)
	# Set an int
	def ioctl_set_int(self, op, value):
		buffer = struct.pack(int_format, value)
		self.ioctl(op, buffer)
	# Set two ints
	def ioctl_set_int2(self, op, values):
		buffer = struct.pack(int_array2_format, *values)
		self.ioctl(op, buffer)
	# Set n ints, where n is the number of elements in the values sequence
	def ioctl_set_int_array(self, op, values):
		l = len(values)
		format = "i"*l
		buffer = struct.pack(format, *values)
		self.ioctl(op, buffer)

	def __get_bits(self, name, name_max):
		ev_bit = Event.typeMap.toNumber(name)
		if name == 'EV_SYN' or self.ev_bits.test_bit(ev_bit):
			bits = "\0"*NBYTES(Event.codeMaps[name].toNumber(name_max))
			l = len(bits)
			try:
				bits = self.ioctl_get_bytes(EVIOCGBIT(ev_bit, l),l)
				bits = bitmap(bits=bits)
			except (IOError), err:
				bits = bitmap(bits=None)
			return bits
		else:
			return bitmap(bits=None)

	def __init__(self, filename):
		BaseDevice.__init__(self)
		self.path = filename
		self.fd = os.open(filename, os.O_RDWR)#|os.O_NONBLOCK)
		

		# Get some important, non-changing info about the device
		try:
			self.version = self.ioctl_get_int(EVIOCGVERSION)[0]
		except (IOError), err:
			self.version = -1

		try:
			buffer = self.ioctl_get_bytes(EVIOCGID, input_id_size)
			values = struct.unpack(input_id_format, buffer)
			id = dict(zip(('bustype', 'vendor', 'product', 'version'), values))
			self.id = id
		except (IOError), err:
			self.id = None

		try:
			self.name = self.ioctl_get_astring(EVIOCGNAME)
		except (IOError), err:
			self.name = '<ERROR: ioctl(EVIOCGNAME): ' + str(err) + ' >'
		try:
			self.phys = self.ioctl_get_astring(EVIOCGPHYS)
		except (IOError), err:
			self.phys = '<ERROR: ioctl(EVIOCGPHYS): ' + str(err) + ' >'
		try:
			self.uniq = self.ioctl_get_astring(EVIOCGUNIQ)
		except (IOError), err:
			self.uniq = '<ERROR: ioctl(EVIOCUNIQ): ' + str(err) + ' >'

		# Fill out bitmaps showing what types of events we get
		l = NBYTES(Event.typeMap.toNumber('EV_MAX'))
		bits = self.ioctl_get_bytes(EVIOCGBIT(0, l), l)
		self.ev_bits = bitmap(bits=bits)
		self.ev_bits  = self.__get_bits('EV_SYN', 'EV_MAX')

		self.key_bits = self.__get_bits('EV_KEY', 'KEY_MAX')
		self.rel_bits = self.__get_bits('EV_REL', 'REL_MAX')
		self.abs_bits = self.__get_bits('EV_ABS', 'ABS_MAX')
		self.msc_bits = self.__get_bits('EV_MSC', 'MSC_MAX')
		self.led_bits = self.__get_bits('EV_LED', 'LED_MAX')
		self.snd_bits = self.__get_bits('EV_SND', 'SND_MAX')
		self.rep_bits = self.__get_bits('EV_REP', 'REP_MAX')

		self.get_axis()

		self.grabbed = False

		self.ev_num = 0
#		self.grab()
	def __repr__(self):
		l = ['Event Device: ', self.path, 
			'\n\tNAME: ', self.name,
			'\n\tPHYS: ', self.phys,
			'\n\tUNIQ: ', self.uniq,
			'\n\tBUSTYPE: ', busMap.fromNumber(self.id['bustype']),
			' \tVENDOR: ', str(self.id['vendor']),
			' \tPRODUCT: ', str(self.id['product']),
			' \tVERSION: ', str(self.id['version']),
			'\n\tEVENT PROTOCOL VERSION: ', str(self.version),
			'\n\tEV_BITS: ', self.ev_bits.expand(Event.typeMap)]
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_KEY')):
			l.append('\n\tEV_KEY: ' + self.key_bits.expand(Event.codeMaps['EV_KEY']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_REL')):
			l.append('\n\tEV_REL: ' + self.rel_bits.expand(Event.codeMaps['EV_REL']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_ABS')):
			l.append('\n\tEV_ABS: ' + self.abs_bits.expand(Event.codeMaps['EV_ABS']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_MSC')):
			l.append('\n\tEV_MSC: ' + self.msc_bits.expand(Event.codeMaps['EV_MSC']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_LED')):
			l.append('\n\tEV_LED: ' + self.led_bits.expand(Event.codeMaps['EV_LED']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_SND')):
			l.append('\n\tEV_SND: ' + self.snd_bits.expand(Event.codeMaps['EV_SND']))
		if self.ev_bits.test_bit(Event.typeMap.toNumber('EV_REP')):
			l.append('\n\tEV_REP: ' + self.rep_bits.expand(Event.codeMaps['EV_REP']))
		for name in self.absAxisInfo.keys():
			l.append('\n\t' + name + ': ' + str(self.absAxisInfo[name]))
		return ''.join(l)

	# Convenience functions for getting various event device parameters
	def get_switches(self, length): pass
	def get_repeat(self):
		if not self.repeat is None:
			return dict(zip(('delay', 'period'), self.repeat))
		self.repeat = self.ioctl_get_int2(EVIOCGREP)
		return dict(zip(('delay', 'period'), self.repeat))
	def set_repeat(self, delay, period):
		self.ioctl_set_int2(EVIOCSREP, (delay, period))
		self.repeat = (delay, period)
	# unlike some event ioctls, we don't cache keycodes
	def get_keycode(self, keys):
		buffer = struct.pack(int_array2_format, keys[0], keys[1])
		return struct.unpack(int_array2_format, self.ioctl(EVIOCGKEYCODE, buffer))
	def set_keycode(self, keys):
		return self.ioctl_set_int2(EVIOCSKEYCODE, keys)
	def get_abs(self, abs): pass
	def set_abs(self, abs): pass
	def grab(self):
		if not self.grabbed:
			self.ioctl(EVIOCGRAB, 1L)
			self.grabbed = True
		else:
			self.ioctl(EVIOCGRAB, 0L)
			self.grabbed = False

	def poll(self):
		"""Receive and process all available input events"""
		while 1:
			try:
				buffer = os.read(self.fd, Event.format_size)
			except (OSError), err:
				return
			ev = Event(buffer=buffer)
			self.ev_num = self.ev_num + 1
			print '%d: %s' % (self.ev_num, ev)
			self.update(ev)

	def get_axis(self):
		"""Read device capabilities via ioctl()"""

		# Test for those event types where axis limits are relevant
		ev_bit = Event.typeMap.toNumber('EV_ABS')
		if not self.ev_bits.test_bit(ev_bit):
			return

		# Read each absolute axis limits
		absmap = Event.codeMaps['EV_ABS']
		buffer = "\0"*input_absinfo_size
		self.absAxisInfo = {}
		for name, number in absmap.nameMap.iteritems():
			if number >= absmap.toNumber('ABS_MAX'):
				continue
			if not self.abs_bits.test_bit(number):
				continue
			values = struct.unpack(input_absinfo_format, self.ioctl(EVIOCGABS(number), buffer))
			values = dict(zip(( 'value', 'min', 'max', 'fuzz', 'flat' ),values))
			self.absAxisInfo[name] = values

	def update_EV_ABS(self, event):
		"""Scale the absolute axis into the range [-1, 1] using absAxisInfo"""
		try:
			info = self.absAxisInfo[event.code]
		except KeyError:
			return
		range = float(info['max'] - info['min'])
		self.axes[event.code] = (event.value - info['min']) / range * 2.0 - 1.0


class EnumDict:
	"""A 1:1 mapping from numbers to strings or other objects, for enumerated
	   types and other assigned numbers. The mapping can be queried in either
	   direction. All values, by default, map to themselves.
	   """
	def __init__(self, numberMap):
		self.numberMap = numberMap
		self.nameMap = {}
		for key, value in numberMap.iteritems():
			self.nameMap[value] = key

	def toNumber(self, name):
		return self.nameMap.get(name, name)

	def fromNumber(self, num):
		return self.numberMap.get(num, num)

#
# Useful vim command for updating these tables using copy-paste of these
# #defines from include/linux/input.h:
# :%s/^\#define \([^[:space:]]*\)[[:space:]]\+\(0x[0-9a-fA-F]*\).*$/\t\t\2: "\1",/gc
#

idMap = EnumDict({
	0: "ID_BUS",
	1: "ID_VENDOR",
	2: "ID_PRODUCT",
	3: "ID_VERSION",
})

busMap = EnumDict({
	0x01: "BUS_PCI",
	0x02: "BUS_ISAPNP",
	0x03: "BUS_USB",
	0x04: "BUS_HIL",
	0x05: "BUS_BLUETOOTH",
	0x06: "BUS_VIRTUAL",
	0x10: "BUS_ISA",
	0x11: "BUS_I8042",
	0x12: "BUS_XTKBD",
	0x13: "BUS_RS232",
	0x14: "BUS_GAMEPORT",
	0x15: "BUS_PARPORT",
	0x16: "BUS_AMIGA",
	0x17: "BUS_ADB",
	0x18: "BUS_I2C",
	0x19: "BUS_HOST",
	0x1a: "BUS_GSC",
	0x1b: "BUS_ATARI",
})

class Event:
	"""Represents one linux input system event. It can
	   be encoded and decoded in the 'struct input_event'
	   format used by the kernel. Types and codes are automatically
	   encoded and decoded with the # names used in input.h
	   """
	# format: on AMD64 its LLHHi and *not* LLHHl
	format = "LLHHi"
	format_size = struct.calcsize(format)

	# One check to ensure proper formatting below is to search for the next
	# occurence of the following pattern in vim:
	# "[[:space:]]*$
	codeMaps = {
		"EV_SYN": EnumDict({
		0x00: "EV_SYN",
		0x01: "EV_KEY",
		0x02: "EV_REL",
		0x03: "EV_ABS",
		0x04: "EV_MSC",
		0x05: "EV_SW",
		0x11: "EV_LED",
		0x12: "EV_SND",
		0x14: "EV_REP",
		0x15: "EV_FF",
		0x16: "EV_PWR",
		0x17: "EV_FF_STATUS",
		0x1f: "EV_MAX",
		}),

		"EV_KEY": EnumDict({
		0: "KEY_RESERVED",
		1: "KEY_ESC",
		2: "KEY_1",
		3: "KEY_2",
		4: "KEY_3",
		5: "KEY_4",
		6: "KEY_5",
		7: "KEY_6",
		8: "KEY_7",
		9: "KEY_8",
		10: "KEY_9",
		11: "KEY_0",
		12: "KEY_MINUS",
		13: "KEY_EQUAL",
		14: "KEY_BACKSPACE",
		15: "KEY_TAB",
		16: "KEY_Q",
		17: "KEY_W",
		18: "KEY_E",
		19: "KEY_R",
		20: "KEY_T",
		21: "KEY_Y",
		22: "KEY_U",
		23: "KEY_I",
		24: "KEY_O",
		25: "KEY_P",
		26: "KEY_LEFTBRACE",
		27: "KEY_RIGHTBRACE",
		28: "KEY_ENTER",
		29: "KEY_LEFTCTRL",
		30: "KEY_A",
		31: "KEY_S",
		32: "KEY_D",
		33: "KEY_F",
		34: "KEY_G",
		35: "KEY_H",
		36: "KEY_J",
		37: "KEY_K",
		38: "KEY_L",
		39: "KEY_SEMICOLON",
		40: "KEY_APOSTROPHE",
		41: "KEY_GRAVE",
		42: "KEY_LEFTSHIFT",
		43: "KEY_BACKSLASH",
		44: "KEY_Z",
		45: "KEY_X",
		46: "KEY_C",
		47: "KEY_V",
		48: "KEY_B",
		49: "KEY_N",
		50: "KEY_M",
		51: "KEY_COMMA",
		52: "KEY_DOT",
		53: "KEY_SLASH",
		54: "KEY_RIGHTSHIFT",
		55: "KEY_KPASTERISK",
		56: "KEY_LEFTALT",
		57: "KEY_SPACE",
		58: "KEY_CAPSLOCK",
		59: "KEY_F1",
		60: "KEY_F2",
		61: "KEY_F3",
		62: "KEY_F4",
		63: "KEY_F5",
		64: "KEY_F6",
		65: "KEY_F7",
		66: "KEY_F8",
		67: "KEY_F9",
		68: "KEY_F10",
		69: "KEY_NUMLOCK",
		70: "KEY_SCROLLLOCK",
		71: "KEY_KP7",
		72: "KEY_KP8",
		73: "KEY_KP9",
		74: "KEY_KPMINUS",
		75: "KEY_KP4",
		76: "KEY_KP5",
		77: "KEY_KP6",
		78: "KEY_KPPLUS",
		79: "KEY_KP1",
		80: "KEY_KP2",
		81: "KEY_KP3",
		82: "KEY_KP0",
		83: "KEY_KPDOT",
		84: "KEY_103RD",
		85: "KEY_F13",
		86: "KEY_102ND",
		87: "KEY_F11",
		88: "KEY_F12",
		89: "KEY_F14",
		90: "KEY_F15",
		91: "KEY_F16",
		92: "KEY_F17",
		93: "KEY_F18",
		94: "KEY_F19",
		95: "KEY_F20",
		96: "KEY_KPENTER",
		97: "KEY_RIGHTCTRL",
		98: "KEY_KPSLASH",
		99: "KEY_SYSRQ",
		100: "KEY_RIGHTALT",
		101: "KEY_LINEFEED",
		102: "KEY_HOME",
		103: "KEY_UP",
		104: "KEY_PAGEUP",
		105: "KEY_LEFT",
		106: "KEY_RIGHT",
		107: "KEY_END",
		108: "KEY_DOWN",
		109: "KEY_PAGEDOWN",
		110: "KEY_INSERT",
		111: "KEY_DELETE",
		112: "KEY_MACRO",
		113: "KEY_MUTE",
		114: "KEY_VOLUMEDOWN",
		115: "KEY_VOLUMEUP",
		116: "KEY_POWER",
		117: "KEY_KPEQUAL",
		118: "KEY_KPPLUSMINUS",
		119: "KEY_PAUSE",
		120: "KEY_F21",
		121: "KEY_F22",
		122: "KEY_F23",
		123: "KEY_F24",
		124: "KEY_KPCOMMA",
		125: "KEY_LEFTMETA",
		126: "KEY_RIGHTMETA",
		127: "KEY_COMPOSE",
		128: "KEY_STOP",
		129: "KEY_AGAIN",
		130: "KEY_PROPS",
		131: "KEY_UNDO",
		132: "KEY_FRONT",
		133: "KEY_COPY",
		134: "KEY_OPEN",
		135: "KEY_PASTE",
		136: "KEY_FIND",
		137: "KEY_CUT",
		138: "KEY_HELP",
		139: "KEY_MENU",
		140: "KEY_CALC",
		141: "KEY_SETUP",
		142: "KEY_SLEEP",
		143: "KEY_WAKEUP",
		144: "KEY_FILE",
		145: "KEY_SENDFILE",
		146: "KEY_DELETEFILE",
		147: "KEY_XFER",
		148: "KEY_PROG1",
		149: "KEY_PROG2",
		150: "KEY_WWW",
		151: "KEY_MSDOS",
		152: "KEY_COFFEE",
		153: "KEY_DIRECTION",
		154: "KEY_CYCLEWINDOWS",
		155: "KEY_MAIL",
		156: "KEY_BOOKMARKS",
		157: "KEY_COMPUTER",
		158: "KEY_BACK",
		159: "KEY_FORWARD",
		160: "KEY_CLOSECD",
		161: "KEY_EJECTCD",
		162: "KEY_EJECTCLOSECD",
		163: "KEY_NEXTSONG",
		164: "KEY_PLAYPAUSE",
		165: "KEY_PREVIOUSSONG",
		166: "KEY_STOPCD",
		167: "KEY_RECORD",
		168: "KEY_REWIND",
		169: "KEY_PHONE",
		170: "KEY_ISO",
		171: "KEY_CONFIG",
		172: "KEY_HOMEPAGE",
		173: "KEY_REFRESH",
		174: "KEY_EXIT",
		175: "KEY_MOVE",
		176: "KEY_EDIT",
		177: "KEY_SCROLLUP",
		178: "KEY_SCROLLDOWN",
		179: "KEY_KPLEFTPAREN",
		180: "KEY_KPRIGHTPAREN",
		181: "KEY_INTL1",
		182: "KEY_INTL2",
		183: "KEY_INTL3",
		184: "KEY_INTL4",
		185: "KEY_INTL5",
		186: "KEY_INTL6",
		187: "KEY_INTL7",
		188: "KEY_INTL8",
		189: "KEY_INTL9",
		190: "KEY_LANG1",
		191: "KEY_LANG2",
		192: "KEY_LANG3",
		193: "KEY_LANG4",
		194: "KEY_LANG5",
		195: "KEY_LANG6",
		196: "KEY_LANG7",
		197: "KEY_LANG8",
		198: "KEY_LANG9",
		200: "KEY_PLAYCD",
		201: "KEY_PAUSECD",
		202: "KEY_PROG3",
		203: "KEY_PROG4",
		205: "KEY_SUSPEND",
		206: "KEY_CLOSE",
		220: "KEY_UNKNOWN",
		224: "KEY_BRIGHTNESSDOWN",
		225: "KEY_BRIGHTNESSUP",
		0x100: "BTN_0 (BTN_MISC)", # aka BTN_MISC
		0x101: "BTN_1",
		0x102: "BTN_2",
		0x103: "BTN_3",
		0x104: "BTN_4",
		0x105: "BTN_5",
		0x106: "BTN_6",
		0x107: "BTN_7",
		0x108: "BTN_8",
		0x109: "BTN_9",
		0x110: "BTN_LEFT (BTN_MOUSE)", # aka BTN_MOUSE
		0x111: "BTN_RIGHT",
		0x112: "BTN_MIDDLE",
		0x113: "BTN_SIDE",
		0x114: "BTN_EXTRA",
		0x115: "BTN_FORWARD",
		0x116: "BTN_BACK",
		0x117: "BTN_TASK",
		0x120: "BTN_TRIGGER (BTN_JOYSTICK)", # aka BTN_JOYSTICK
		0x121: "BTN_THUMB",
		0x122: "BTN_THUMB2",
		0x123: "BTN_TOP",
		0x124: "BTN_TOP2",
		0x125: "BTN_PINKIE",
		0x126: "BTN_BASE",
		0x127: "BTN_BASE2",
		0x128: "BTN_BASE3",
		0x129: "BTN_BASE4",
		0x12a: "BTN_BASE5",
		0x12b: "BTN_BASE6",
		0x12f: "BTN_DEAD",
		0x130: "BTN_A (BTN_GAMEPAD)", # aka BTN_GAMEPAD
		0x131: "BTN_B",
		0x132: "BTN_C",
		0x133: "BTN_X",
		0x134: "BTN_Y",
		0x135: "BTN_Z",
		0x136: "BTN_TL",
		0x137: "BTN_TR",
		0x138: "BTN_TL2",
		0x139: "BTN_TR2",
		0x13a: "BTN_SELECT",
		0x13b: "BTN_START",
		0x13c: "BTN_MODE",
		0x13d: "BTN_THUMBL",
		0x13e: "BTN_THUMBR",
		0x140: "BTN_TOOL_PEN (BTN_DIGI)", # aka BTN_DIGI
		0x141: "BTN_TOOL_RUBBER",
		0x142: "BTN_TOOL_BRUSH",
		0x143: "BTN_TOOL_PENCIL",
		0x144: "BTN_TOOL_AIRBRUSH",
		0x145: "BTN_TOOL_FINGER",
		0x146: "BTN_TOOL_MOUSE",
		0x147: "BTN_TOOL_LENS",
		0x14a: "BTN_TOUCH",
		0x14b: "BTN_STYLUS",
		0x14c: "BTN_STYLUS2",
		0x14d: "BTN_TOOL_DOUBLETAP",
		0x14e: "BTN_TOOL_TRIPLETAP",
		0x150: "BTN_GEAR_DOWN (BTN_WHEEL)", # aka BTN_WHEEL
		0x150: "BTN_GEAR_UP",
		0x160: "KEY_OK",
		0x161: "KEY_SELECT",
		0x162: "KEY_GOTO",
		0x163: "KEY_CLEAR",
		0x164: "KEY_POWER2",
		0x165: "KEY_OPTION",
		0x166: "KEY_INFO",
		0x167: "KEY_TIME",
		0x168: "KEY_VENDOR",
		0x169: "KEY_ARCHIVE",
		0x16a: "KEY_PROGRAM",
		0x16b: "KEY_CHANNEL",
		0x16c: "KEY_FAVORITES",
		0x16d: "KEY_EPG",
		0x16e: "KEY_PVR",
		0x16f: "KEY_MHP",
		0x170: "KEY_LANGUAGE",
		0x171: "KEY_TITLE",
		0x172: "KEY_SUBTITLE",
		0x173: "KEY_ANGLE",
		0x174: "KEY_ZOOM",
		0x175: "KEY_MODE",
		0x176: "KEY_KEYBOARD",
		0x177: "KEY_SCREEN",
		0x178: "KEY_PC",
		0x179: "KEY_TV",
		0x17a: "KEY_TV2",
		0x17b: "KEY_VCR",
		0x17c: "KEY_VCR2",
		0x17d: "KEY_SAT",
		0x17e: "KEY_SAT2",
		0x17f: "KEY_CD",
		0x180: "KEY_TAPE",
		0x181: "KEY_RADIO",
		0x182: "KEY_TUNER",
		0x183: "KEY_PLAYER",
		0x184: "KEY_TEXT",
		0x185: "KEY_DVD",
		0x186: "KEY_AUX",
		0x187: "KEY_MP3",
		0x188: "KEY_AUDIO",
		0x189: "KEY_VIDEO",
		0x18a: "KEY_DIRECTORY",
		0x18b: "KEY_LIST",
		0x18c: "KEY_MEMO",
		0x18d: "KEY_CALENDAR",
		0x18e: "KEY_RED",
		0x18f: "KEY_GREEN",
		0x190: "KEY_YELLOW",
		0x191: "KEY_BLUE",
		0x192: "KEY_CHANNELUP",
		0x193: "KEY_CHANNELDOWN",
		0x194: "KEY_FIRST",
		0x195: "KEY_LAST",
		0x196: "KEY_AB",
		0x197: "KEY_NEXT",
		0x198: "KEY_RESTART",
		0x199: "KEY_SLOW",
		0x19a: "KEY_SHUFFLE",
		0x19b: "KEY_BREAK",
		0x19c: "KEY_PREVIOUS",
		0x19d: "KEY_DIGITS",
		0x19e: "KEY_TEEN",
		0x19f: "KEY_TWEN",
		0x1a0: "KEY_VIDEOPHONE",
		0x1a1: "KEY_GAMES",
		0x1a2: "KEY_ZOOMIN",
		0x1a3: "KEY_ZOOMOUT",
		0x1a4: "KEY_ZOOMRESET",
		0x1a5: "KEY_WORDPROCESSOR",
		0x1a6: "KEY_EDITOR",
		0x1a7: "KEY_SPREADSHEET",
		0x1a8: "KEY_GRAPHICSEDITOR",
		0x1a9: "KEY_PRESENTATION",
		0x1aa: "KEY_DATABASE",
		0x1ab: "KEY_NEWS",
		0x1ac: "KEY_VOICEMAIL",
		0x1ad: "KEY_ADDRESSBOOK",
		0x1ae: "KEY_MESSENGER",
		0x1af: "KEY_DISPLAYTOGGLE",
		0x1b0: "KEY_SPELLCHECK",
		0x1b1: "KEY_LOGOFF",

		0x1b2: "KEY_DOLLAR",
		0x1b3: "KEY_EURO",

		0x1b4: "KEY_FRAMEBACK",
		0x1b5: "KEY_FRAMEFORWARD",

		0x1b6: "KEY_CONTEXT_MENU",

		0x1c0: "KEY_DEL_EOL",
		0x1c1: "KEY_DEL_EOS",
		0x1c2: "KEY_INS_LINE",
		0x1c3: "KEY_DEL_LINE",

		0x1d0: "KEY_FN",
		0x1d1: "KEY_FN_ESC",
		0x1d2: "KEY_FN_F1",
		0x1d3: "KEY_FN_F2",
		0x1d4: "KEY_FN_F3",
		0x1d5: "KEY_FN_F4",
		0x1d6: "KEY_FN_F5",
		0x1d7: "KEY_FN_F6",
		0x1d8: "KEY_FN_F7",
		0x1d9: "KEY_FN_F8",
		0x1da: "KEY_FN_F9",
		0x1db: "KEY_FN_F10",
		0x1dc: "KEY_FN_F11",
		0x1dd: "KEY_FN_F12",
		0x1de: "KEY_FN_1",
		0x1df: "KEY_FN_2",
		0x1e0: "KEY_FN_D",
		0x1e1: "KEY_FN_E",
		0x1e2: "KEY_FN_F",
		0x1e3: "KEY_FN_S",
		0x1e4: "KEY_FN_B",

		0x1f1: "KEY_BRL_DOT1",
		0x1f2: "KEY_BRL_DOT2",
		0x1f3: "KEY_BRL_DOT3",
		0x1f4: "KEY_BRL_DOT4",
		0x1f5: "KEY_BRL_DOT5",
		0x1f6: "KEY_BRL_DOT6",
		0x1f7: "KEY_BRL_DOT7",
		0x1f8: "KEY_BRL_DOT8",
		0x1f9: "KEY_BRL_DOT9",
		0x1fa: "KEY_BRL_DOT10",

		0x1ff: "KEY_MAX",
		}),

		"EV_REL": EnumDict({
		0x00: "REL_X",
		0x01: "REL_Y",
		0x02: "REL_Z",
		0x03: "REL_RX",
		0x04: "REL_RY",
		0x05: "REL_RZ",
		0x06: "REL_HWHEEL",
		0x07: "REL_DIAL",
		0x08: "REL_WHEEL",
		0x09: "REL_MISC",
		0x0f: "REL_MAX",
		}),

		"EV_ABS": EnumDict({
		0x00: "ABS_X",
		0x01: "ABS_Y",
		0x02: "ABS_Z",
		0x03: "ABS_RX",
		0x04: "ABS_RY",
		0x05: "ABS_RZ",
		0x06: "ABS_THROTTLE",
		0x07: "ABS_RUDDER",
		0x08: "ABS_WHEEL",
		0x09: "ABS_GAS",
		0x0a: "ABS_BRAKE",
		0x10: "ABS_HAT0X",
		0x11: "ABS_HAT0Y",
		0x12: "ABS_HAT1X",
		0x13: "ABS_HAT1Y",
		0x14: "ABS_HAT2X",
		0x15: "ABS_HAT2Y",
		0x16: "ABS_HAT3X",
		0x17: "ABS_HAT3Y",
		0x18: "ABS_PRESSURE",
		0x19: "ABS_DISTANCE",
		0x1a: "ABS_TILT_X",
		0x1b: "ABS_TILT_Y",
		0x1c: "ABS_TOOL_WIDTH",
		0x20: "ABS_VOLUME",
		0x28: "ABS_MISC",
		0x3f: "ABS_MAX",
		}),

		"EV_SW": EnumDict({
		0x00: "SW_LID",
		0x01: "SW_TABLET_MODE",
		0x02: "SW_HEADPHONE_INSERT",
		0x03: "SW_RADIO",
		0x0f: "SW_MAX",
		}),

		"EV_MSC": EnumDict({
		0x00: "MSC_SERIAL",
		0x01: "MSC_PULSELED",
		0x02: "MSC_GESTURE",
		0x03: "MSC_RAW",
		0x04: "MSC_SCAN",
		0x07: "MSC_MAX",
		}),

		"EV_LED": EnumDict({
		0x00: "LED_NUML",
		0x01: "LED_CAPSL",
		0x02: "LED_SCROLLL",
		0x03: "LED_COMPOSE",
		0x04: "LED_KANA",
		0x05: "LED_SLEEP",
		0x06: "LED_SUSPEND",
		0x07: "LED_MUTE",
		0x08: "LED_MISC",
		0x09: "LED_MAIL",
		0x0a: "LED_CHARGING",
		0x0f: "LED_MAX",
		}),

		"EV_REP": EnumDict({
		0x00: "REP_DELAY",
		0x01: "REP_PERIOD",
		0x01: "REP_MAX",
		}),

		"EV_SND": EnumDict({
		0x00: "SND_CLICK",
		0x01: "SND_BELL",
		0x02: "SND_TONE",
		0x07: "SND_MAX",
		}),
		}
	typeMap = codeMaps["EV_SYN"]


# TODO FF (force feedback) constants

	# If there were no matches before this point "
	# then the check passed. (see comment preceding these EnumDict tables)

	def __init__(self, timestamp=0, type=0, code=0, value=0, buffer=None, readFrom=None):
		self.timestamp = timestamp
		self.type = type
		self.code = code
		self.value = value
		#print hexbytes(buffer)
		if (buffer is not None) and (len(buffer) >= 1): #self.format_size):
			self.unpack(buffer)
		if readFrom is not None:
			self.readFrom(readFrom)

	def __repr__(self):
		return "<Event timestamp=%r type=%r code=%r value=%r>" % (
			self.timestamp, self.type, self.code, self.value)

	def pack(self):
		"""Pack this event into an input_event struct in
		   the local machine's byte order.
		   """
		secs = int(self.timestamp)
		usecs = int((self.timestamp - secs) * 1000000)
		packedType = self.typeMap.toNumber(self.type)
		if self.type in self.codeMaps:
			packedCode = self.codeMaps[self.type].toNumber(self.code)
		else:
			packedCode = self.code
		return struct.pack(self.format, secs, usecs, packedType,
						   packedCode, self.value)

	def unpack(self, s):
		"""Unpack ourselves from the given string,, an
		   input_event struct in the local byte order.
		   """
		secs, usecs, packedType, packedCode, self.value = struct.unpack(self.format, s)
		self.timestamp = secs + (usecs / 1000000.0)
		self.type = self.typeMap.fromNumber(packedType)
		if self.type in self.codeMaps:
			self.code = self.codeMaps[self.type].fromNumber(packedCode)
		else:
			self.code = packedCode

	def readFrom(self, stream):
		"""Read the next event from the given file-like object"""
		self.unpack(stream.read(self.format_size))


if __name__ == "__main__":
	demo()

### The End ###


